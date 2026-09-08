import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_drawing/path_drawing.dart';

import '../data/catalog.dart';
import '../theme/app_colors.dart';

/// One state outline, already parsed into a Flutter [Path] in viewBox space.
class MapState {
  MapState({required this.id, required this.name, required this.path})
      : bounds = path.getBounds();

  final String id;
  final String name;
  final Path path;
  final Rect bounds;
}

/// Loads and parses the India outline once, then hands out the same instance.
///
/// Parsing 36 paths is not free, so doing it per rebuild would make the tab
/// visibly janky on a low-end phone.
class IndiaMapData {
  IndiaMapData._(this.states, this.viewBox);

  final List<MapState> states;
  final Size viewBox;

  static IndiaMapData? _cached;
  static Future<IndiaMapData>? _loading;

  /// The map file predates the 2019 reorganisation and uses older two letter
  /// codes. Four of them differ from what the database stores, and each
  /// mismatch silently makes a whole state untappable, so they are aliased
  /// rather than left to chance.
  ///
  ///   or -> od   Odisha
  ///   ct -> cg   Chhattisgarh
  ///   tg -> ts   Telangana
  ///   ut -> uk   Uttarakhand
  static const _idAliases = {
    'or': 'od',
    'ct': 'cg',
    'tg': 'ts',
    'ut': 'uk',
  };

  static String canonical(String mapId) => _idAliases[mapId] ?? mapId;

  static Future<IndiaMapData> load() {
    final cached = _cached;
    if (cached != null) return Future.value(cached);

    // Clear the in-flight future when it settles. Holding on to a failed or
    // abandoned load would cache the failure forever, so the map could never
    // recover on a later visit to the tab.
    return _loading ??= _parse().whenComplete(() => _loading = null);
  }

  @visibleForTesting
  static void resetCache() {
    _cached = null;
    _loading = null;
  }

  static Future<IndiaMapData> _parse() async {
    final raw = await rootBundle.loadString('assets/map/india_states.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;

    final vb = (json['viewBox'] as String).split(RegExp(r'\s+'));
    final size = Size(double.parse(vb[2]), double.parse(vb[3]));

    final states = <MapState>[
      for (final s in json['states'] as List)
        MapState(
          id: canonical(s['id'] as String),
          name: s['name'] as String,
          path: parseSvgPathData(s['d'] as String),
        ),
    ];

    return _cached = IndiaMapData._(states, size);
  }
}

/// Tappable map of India.
///
/// States we carry crafts from are filled and labelled; the rest are drawn
/// muted so the eye goes where the products are.
class IndiaMap extends StatefulWidget {
  const IndiaMap({
    super.key,
    required this.onState,
    this.selectedId,
    this.activeIds = const {},
  });

  /// Called with the state's id and its name, so a caller can open a state we
  /// carry no products for without inventing a label.
  final void Function(String stateId, String stateName) onState;
  final String? selectedId;
  final Set<String> activeIds;

  @override
  State<IndiaMap> createState() => _IndiaMapState();
}

class _IndiaMapState extends State<IndiaMap> {
  IndiaMapData? _data;
  String? _pressed;
  Object? _error;

  @override
  void initState() {
    super.initState();
    IndiaMapData.load().then(
      (d) {
        if (mounted) setState(() => _data = d);
      },
      // A map that fails to parse must not take the tab down with it.
      onError: (Object e) {
        if (mounted) setState(() => _error = e);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    if (data == null) {
      // Static placeholder rather than a spinner: parsing takes a few tens of
      // milliseconds, so a spinner would only flash. It also keeps the tree
      // settled, which matters for tests and for accessibility announcements.
      return AspectRatio(
        aspectRatio: 612 / 696,
        child: Center(
          child: Icon(
            _error == null ? Icons.public_outlined : Icons.map_outlined,
            size: 40,
            color: AppColors.line,
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: data.viewBox.width / data.viewBox.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale = constraints.maxWidth / data.viewBox.width;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) {
              final p = details.localPosition / scale;
              // Reverse order so smaller states drawn last win the hit.
              for (final st in data.states.reversed) {
                if (st.path.contains(p)) {
                  setState(() => _pressed = st.id);
                  widget.onState(st.id, st.name);
                  return;
                }
              }
            },
            child: CustomPaint(
              painter: _MapPainter(
                data: data,
                scale: scale,
                selectedId: widget.selectedId ?? _pressed,
                activeIds: widget.activeIds,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  _MapPainter({
    required this.data,
    required this.scale,
    required this.selectedId,
    required this.activeIds,
  });

  final IndiaMapData data;
  final double scale;
  final String? selectedId;
  final Set<String> activeIds;

  static const _fills = <Color>[
    Color(0xFFE6D9C0),
    Color(0xFFDCC8B4),
    Color(0xFFD3D9C8),
    Color(0xFFE0CFC8),
    Color(0xFFD5D9E0),
    Color(0xFFE3D6C6),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(scale);

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7 / scale
      ..color = AppColors.white;

    for (var i = 0; i < data.states.length; i++) {
      final st = data.states[i];
      final active = activeIds.isEmpty || activeIds.contains(st.id);
      final selected = st.id == selectedId;

      final fill = Paint()
        ..style = PaintingStyle.fill
        ..color = selected
            ? AppColors.terracotta
            : active
                ? _fills[i % _fills.length]
                : const Color(0xFFEFEBE3);

      canvas.drawPath(st.path, fill);
      canvas.drawPath(st.path, stroke);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_MapPainter old) =>
      old.selectedId != selectedId ||
      old.scale != scale ||
      old.activeIds != activeIds;
}

/// The states we actually stock, for dimming everything else.
Set<String> get craftStateIds => Catalog.states.map((s) => s.id).toSet();

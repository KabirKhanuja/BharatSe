// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outbox_db.dart';

// ignore_for_file: type=lint
class $OutboxEntriesTable extends OutboxEntries
    with TableInfo<$OutboxEntriesTable, OutboxEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sentMeta = const VerificationMeta('sent');
  @override
  late final GeneratedColumn<bool> sent = GeneratedColumn<bool>(
    'sent',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sent" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    clientId,
    entity,
    op,
    payload,
    createdAt,
    attempts,
    lastError,
    sent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('sent')) {
      context.handle(
        _sentMeta,
        sent.isAcceptableOrUnknown(data['sent']!, _sentMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  OutboxEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxEntry(
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      op: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      sent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sent'],
      )!,
    );
  }

  @override
  $OutboxEntriesTable createAlias(String alias) {
    return $OutboxEntriesTable(attachedDatabase, alias);
  }
}

class OutboxEntry extends DataClass implements Insertable<OutboxEntry> {
  final String clientId;
  final String entity;
  final String op;
  final String payload;
  final DateTime createdAt;
  final int attempts;
  final String? lastError;
  final bool sent;
  const OutboxEntry({
    required this.clientId,
    required this.entity,
    required this.op,
    required this.payload,
    required this.createdAt,
    required this.attempts,
    this.lastError,
    required this.sent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_id'] = Variable<String>(clientId);
    map['entity'] = Variable<String>(entity);
    map['op'] = Variable<String>(op);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['sent'] = Variable<bool>(sent);
    return map;
  }

  OutboxEntriesCompanion toCompanion(bool nullToAbsent) {
    return OutboxEntriesCompanion(
      clientId: Value(clientId),
      entity: Value(entity),
      op: Value(op),
      payload: Value(payload),
      createdAt: Value(createdAt),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      sent: Value(sent),
    );
  }

  factory OutboxEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxEntry(
      clientId: serializer.fromJson<String>(json['clientId']),
      entity: serializer.fromJson<String>(json['entity']),
      op: serializer.fromJson<String>(json['op']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      sent: serializer.fromJson<bool>(json['sent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientId': serializer.toJson<String>(clientId),
      'entity': serializer.toJson<String>(entity),
      'op': serializer.toJson<String>(op),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
      'sent': serializer.toJson<bool>(sent),
    };
  }

  OutboxEntry copyWith({
    String? clientId,
    String? entity,
    String? op,
    String? payload,
    DateTime? createdAt,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
    bool? sent,
  }) => OutboxEntry(
    clientId: clientId ?? this.clientId,
    entity: entity ?? this.entity,
    op: op ?? this.op,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
    sent: sent ?? this.sent,
  );
  OutboxEntry copyWithCompanion(OutboxEntriesCompanion data) {
    return OutboxEntry(
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      entity: data.entity.present ? data.entity.value : this.entity,
      op: data.op.present ? data.op.value : this.op,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      sent: data.sent.present ? data.sent.value : this.sent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntry(')
          ..write('clientId: $clientId, ')
          ..write('entity: $entity, ')
          ..write('op: $op, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('sent: $sent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    clientId,
    entity,
    op,
    payload,
    createdAt,
    attempts,
    lastError,
    sent,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxEntry &&
          other.clientId == this.clientId &&
          other.entity == this.entity &&
          other.op == this.op &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.sent == this.sent);
}

class OutboxEntriesCompanion extends UpdateCompanion<OutboxEntry> {
  final Value<String> clientId;
  final Value<String> entity;
  final Value<String> op;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<bool> sent;
  final Value<int> rowid;
  const OutboxEntriesCompanion({
    this.clientId = const Value.absent(),
    this.entity = const Value.absent(),
    this.op = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.sent = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboxEntriesCompanion.insert({
    required String clientId,
    required String entity,
    required String op,
    required String payload,
    required DateTime createdAt,
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.sent = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : clientId = Value(clientId),
       entity = Value(entity),
       op = Value(op),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<OutboxEntry> custom({
    Expression<String>? clientId,
    Expression<String>? entity,
    Expression<String>? op,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<bool>? sent,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientId != null) 'client_id': clientId,
      if (entity != null) 'entity': entity,
      if (op != null) 'op': op,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (sent != null) 'sent': sent,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboxEntriesCompanion copyWith({
    Value<String>? clientId,
    Value<String>? entity,
    Value<String>? op,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<bool>? sent,
    Value<int>? rowid,
  }) {
    return OutboxEntriesCompanion(
      clientId: clientId ?? this.clientId,
      entity: entity ?? this.entity,
      op: op ?? this.op,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      sent: sent ?? this.sent,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (sent.present) {
      map['sent'] = Variable<bool>(sent.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntriesCompanion(')
          ..write('clientId: $clientId, ')
          ..write('entity: $entity, ')
          ..write('op: $op, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('sent: $sent, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalProductsTable extends LocalProducts
    with TableInfo<$LocalProductsTable, LocalProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleEnMeta = const VerificationMeta(
    'titleEn',
  );
  @override
  late final GeneratedColumn<String> titleEn = GeneratedColumn<String>(
    'title_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleHiMeta = const VerificationMeta(
    'titleHi',
  );
  @override
  late final GeneratedColumn<String> titleHi = GeneratedColumn<String>(
    'title_hi',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionEnMeta = const VerificationMeta(
    'descriptionEn',
  );
  @override
  late final GeneratedColumn<String> descriptionEn = GeneratedColumn<String>(
    'description_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionHiMeta = const VerificationMeta(
    'descriptionHi',
  );
  @override
  late final GeneratedColumn<String> descriptionHi = GeneratedColumn<String>(
    'description_hi',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _materialMeta = const VerificationMeta(
    'material',
  );
  @override
  late final GeneratedColumn<String> material = GeneratedColumn<String>(
    'material',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _techniqueMeta = const VerificationMeta(
    'technique',
  );
  @override
  late final GeneratedColumn<String> technique = GeneratedColumn<String>(
    'technique',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hoursOfWorkMeta = const VerificationMeta(
    'hoursOfWork',
  );
  @override
  late final GeneratedColumn<double> hoursOfWork = GeneratedColumn<double>(
    'hours_of_work',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _materialCostMeta = const VerificationMeta(
    'materialCost',
  );
  @override
  late final GeneratedColumn<int> materialCost = GeneratedColumn<int>(
    'material_cost',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceFloorMeta = const VerificationMeta(
    'priceFloor',
  );
  @override
  late final GeneratedColumn<int> priceFloor = GeneratedColumn<int>(
    'price_floor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
    'price',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagePathsMeta = const VerificationMeta(
    'imagePaths',
  );
  @override
  late final GeneratedColumn<String> imagePaths = GeneratedColumn<String>(
    'image_paths',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _remoteImageUrlsMeta = const VerificationMeta(
    'remoteImageUrls',
  );
  @override
  late final GeneratedColumn<String> remoteImageUrls = GeneratedColumn<String>(
    'remote_image_urls',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    clientId,
    serverId,
    ownerId,
    titleEn,
    titleHi,
    descriptionEn,
    descriptionHi,
    category,
    material,
    technique,
    hoursOfWork,
    materialCost,
    priceFloor,
    price,
    imagePaths,
    remoteImageUrls,
    synced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalProduct> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    }
    if (data.containsKey('title_en')) {
      context.handle(
        _titleEnMeta,
        titleEn.isAcceptableOrUnknown(data['title_en']!, _titleEnMeta),
      );
    }
    if (data.containsKey('title_hi')) {
      context.handle(
        _titleHiMeta,
        titleHi.isAcceptableOrUnknown(data['title_hi']!, _titleHiMeta),
      );
    }
    if (data.containsKey('description_en')) {
      context.handle(
        _descriptionEnMeta,
        descriptionEn.isAcceptableOrUnknown(
          data['description_en']!,
          _descriptionEnMeta,
        ),
      );
    }
    if (data.containsKey('description_hi')) {
      context.handle(
        _descriptionHiMeta,
        descriptionHi.isAcceptableOrUnknown(
          data['description_hi']!,
          _descriptionHiMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('material')) {
      context.handle(
        _materialMeta,
        material.isAcceptableOrUnknown(data['material']!, _materialMeta),
      );
    }
    if (data.containsKey('technique')) {
      context.handle(
        _techniqueMeta,
        technique.isAcceptableOrUnknown(data['technique']!, _techniqueMeta),
      );
    }
    if (data.containsKey('hours_of_work')) {
      context.handle(
        _hoursOfWorkMeta,
        hoursOfWork.isAcceptableOrUnknown(
          data['hours_of_work']!,
          _hoursOfWorkMeta,
        ),
      );
    }
    if (data.containsKey('material_cost')) {
      context.handle(
        _materialCostMeta,
        materialCost.isAcceptableOrUnknown(
          data['material_cost']!,
          _materialCostMeta,
        ),
      );
    }
    if (data.containsKey('price_floor')) {
      context.handle(
        _priceFloorMeta,
        priceFloor.isAcceptableOrUnknown(data['price_floor']!, _priceFloorMeta),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('image_paths')) {
      context.handle(
        _imagePathsMeta,
        imagePaths.isAcceptableOrUnknown(data['image_paths']!, _imagePathsMeta),
      );
    }
    if (data.containsKey('remote_image_urls')) {
      context.handle(
        _remoteImageUrlsMeta,
        remoteImageUrls.isAcceptableOrUnknown(
          data['remote_image_urls']!,
          _remoteImageUrlsMeta,
        ),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  LocalProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProduct(
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      ),
      titleEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_en'],
      ),
      titleHi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_hi'],
      ),
      descriptionEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_en'],
      ),
      descriptionHi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_hi'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      material: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}material'],
      ),
      technique: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}technique'],
      ),
      hoursOfWork: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hours_of_work'],
      ),
      materialCost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}material_cost'],
      ),
      priceFloor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_floor'],
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price'],
      ),
      imagePaths: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_paths'],
      )!,
      remoteImageUrls: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_image_urls'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LocalProductsTable createAlias(String alias) {
    return $LocalProductsTable(attachedDatabase, alias);
  }
}

class LocalProduct extends DataClass implements Insertable<LocalProduct> {
  final String clientId;
  final String? serverId;

  /// Which account made this. Nullable only because rows written before this
  /// column existed have no answer, and those are hidden from everyone rather
  /// than guessed at: two accounts sharing a phone must not see each other's
  /// catalogue.
  final String? ownerId;
  final String? titleEn;
  final String? titleHi;
  final String? descriptionEn;
  final String? descriptionHi;
  final String? category;
  final String? material;
  final String? technique;
  final double? hoursOfWork;
  final int? materialCost;
  final int? priceFloor;
  final int? price;
  final String imagePaths;

  /// Photographs that live on the server rather than on this phone, for rows
  /// rebuilt after a reinstall. Kept separate from [imagePaths] so a local
  /// file is never confused for a URL.
  final String remoteImageUrls;
  final bool synced;
  final DateTime createdAt;
  const LocalProduct({
    required this.clientId,
    this.serverId,
    this.ownerId,
    this.titleEn,
    this.titleHi,
    this.descriptionEn,
    this.descriptionHi,
    this.category,
    this.material,
    this.technique,
    this.hoursOfWork,
    this.materialCost,
    this.priceFloor,
    this.price,
    required this.imagePaths,
    required this.remoteImageUrls,
    required this.synced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    if (!nullToAbsent || ownerId != null) {
      map['owner_id'] = Variable<String>(ownerId);
    }
    if (!nullToAbsent || titleEn != null) {
      map['title_en'] = Variable<String>(titleEn);
    }
    if (!nullToAbsent || titleHi != null) {
      map['title_hi'] = Variable<String>(titleHi);
    }
    if (!nullToAbsent || descriptionEn != null) {
      map['description_en'] = Variable<String>(descriptionEn);
    }
    if (!nullToAbsent || descriptionHi != null) {
      map['description_hi'] = Variable<String>(descriptionHi);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || material != null) {
      map['material'] = Variable<String>(material);
    }
    if (!nullToAbsent || technique != null) {
      map['technique'] = Variable<String>(technique);
    }
    if (!nullToAbsent || hoursOfWork != null) {
      map['hours_of_work'] = Variable<double>(hoursOfWork);
    }
    if (!nullToAbsent || materialCost != null) {
      map['material_cost'] = Variable<int>(materialCost);
    }
    if (!nullToAbsent || priceFloor != null) {
      map['price_floor'] = Variable<int>(priceFloor);
    }
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<int>(price);
    }
    map['image_paths'] = Variable<String>(imagePaths);
    map['remote_image_urls'] = Variable<String>(remoteImageUrls);
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocalProductsCompanion toCompanion(bool nullToAbsent) {
    return LocalProductsCompanion(
      clientId: Value(clientId),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      ownerId: ownerId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerId),
      titleEn: titleEn == null && nullToAbsent
          ? const Value.absent()
          : Value(titleEn),
      titleHi: titleHi == null && nullToAbsent
          ? const Value.absent()
          : Value(titleHi),
      descriptionEn: descriptionEn == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionEn),
      descriptionHi: descriptionHi == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionHi),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      material: material == null && nullToAbsent
          ? const Value.absent()
          : Value(material),
      technique: technique == null && nullToAbsent
          ? const Value.absent()
          : Value(technique),
      hoursOfWork: hoursOfWork == null && nullToAbsent
          ? const Value.absent()
          : Value(hoursOfWork),
      materialCost: materialCost == null && nullToAbsent
          ? const Value.absent()
          : Value(materialCost),
      priceFloor: priceFloor == null && nullToAbsent
          ? const Value.absent()
          : Value(priceFloor),
      price: price == null && nullToAbsent
          ? const Value.absent()
          : Value(price),
      imagePaths: Value(imagePaths),
      remoteImageUrls: Value(remoteImageUrls),
      synced: Value(synced),
      createdAt: Value(createdAt),
    );
  }

  factory LocalProduct.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProduct(
      clientId: serializer.fromJson<String>(json['clientId']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      ownerId: serializer.fromJson<String?>(json['ownerId']),
      titleEn: serializer.fromJson<String?>(json['titleEn']),
      titleHi: serializer.fromJson<String?>(json['titleHi']),
      descriptionEn: serializer.fromJson<String?>(json['descriptionEn']),
      descriptionHi: serializer.fromJson<String?>(json['descriptionHi']),
      category: serializer.fromJson<String?>(json['category']),
      material: serializer.fromJson<String?>(json['material']),
      technique: serializer.fromJson<String?>(json['technique']),
      hoursOfWork: serializer.fromJson<double?>(json['hoursOfWork']),
      materialCost: serializer.fromJson<int?>(json['materialCost']),
      priceFloor: serializer.fromJson<int?>(json['priceFloor']),
      price: serializer.fromJson<int?>(json['price']),
      imagePaths: serializer.fromJson<String>(json['imagePaths']),
      remoteImageUrls: serializer.fromJson<String>(json['remoteImageUrls']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientId': serializer.toJson<String>(clientId),
      'serverId': serializer.toJson<String?>(serverId),
      'ownerId': serializer.toJson<String?>(ownerId),
      'titleEn': serializer.toJson<String?>(titleEn),
      'titleHi': serializer.toJson<String?>(titleHi),
      'descriptionEn': serializer.toJson<String?>(descriptionEn),
      'descriptionHi': serializer.toJson<String?>(descriptionHi),
      'category': serializer.toJson<String?>(category),
      'material': serializer.toJson<String?>(material),
      'technique': serializer.toJson<String?>(technique),
      'hoursOfWork': serializer.toJson<double?>(hoursOfWork),
      'materialCost': serializer.toJson<int?>(materialCost),
      'priceFloor': serializer.toJson<int?>(priceFloor),
      'price': serializer.toJson<int?>(price),
      'imagePaths': serializer.toJson<String>(imagePaths),
      'remoteImageUrls': serializer.toJson<String>(remoteImageUrls),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalProduct copyWith({
    String? clientId,
    Value<String?> serverId = const Value.absent(),
    Value<String?> ownerId = const Value.absent(),
    Value<String?> titleEn = const Value.absent(),
    Value<String?> titleHi = const Value.absent(),
    Value<String?> descriptionEn = const Value.absent(),
    Value<String?> descriptionHi = const Value.absent(),
    Value<String?> category = const Value.absent(),
    Value<String?> material = const Value.absent(),
    Value<String?> technique = const Value.absent(),
    Value<double?> hoursOfWork = const Value.absent(),
    Value<int?> materialCost = const Value.absent(),
    Value<int?> priceFloor = const Value.absent(),
    Value<int?> price = const Value.absent(),
    String? imagePaths,
    String? remoteImageUrls,
    bool? synced,
    DateTime? createdAt,
  }) => LocalProduct(
    clientId: clientId ?? this.clientId,
    serverId: serverId.present ? serverId.value : this.serverId,
    ownerId: ownerId.present ? ownerId.value : this.ownerId,
    titleEn: titleEn.present ? titleEn.value : this.titleEn,
    titleHi: titleHi.present ? titleHi.value : this.titleHi,
    descriptionEn: descriptionEn.present
        ? descriptionEn.value
        : this.descriptionEn,
    descriptionHi: descriptionHi.present
        ? descriptionHi.value
        : this.descriptionHi,
    category: category.present ? category.value : this.category,
    material: material.present ? material.value : this.material,
    technique: technique.present ? technique.value : this.technique,
    hoursOfWork: hoursOfWork.present ? hoursOfWork.value : this.hoursOfWork,
    materialCost: materialCost.present ? materialCost.value : this.materialCost,
    priceFloor: priceFloor.present ? priceFloor.value : this.priceFloor,
    price: price.present ? price.value : this.price,
    imagePaths: imagePaths ?? this.imagePaths,
    remoteImageUrls: remoteImageUrls ?? this.remoteImageUrls,
    synced: synced ?? this.synced,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalProduct copyWithCompanion(LocalProductsCompanion data) {
    return LocalProduct(
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      titleEn: data.titleEn.present ? data.titleEn.value : this.titleEn,
      titleHi: data.titleHi.present ? data.titleHi.value : this.titleHi,
      descriptionEn: data.descriptionEn.present
          ? data.descriptionEn.value
          : this.descriptionEn,
      descriptionHi: data.descriptionHi.present
          ? data.descriptionHi.value
          : this.descriptionHi,
      category: data.category.present ? data.category.value : this.category,
      material: data.material.present ? data.material.value : this.material,
      technique: data.technique.present ? data.technique.value : this.technique,
      hoursOfWork: data.hoursOfWork.present
          ? data.hoursOfWork.value
          : this.hoursOfWork,
      materialCost: data.materialCost.present
          ? data.materialCost.value
          : this.materialCost,
      priceFloor: data.priceFloor.present
          ? data.priceFloor.value
          : this.priceFloor,
      price: data.price.present ? data.price.value : this.price,
      imagePaths: data.imagePaths.present
          ? data.imagePaths.value
          : this.imagePaths,
      remoteImageUrls: data.remoteImageUrls.present
          ? data.remoteImageUrls.value
          : this.remoteImageUrls,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProduct(')
          ..write('clientId: $clientId, ')
          ..write('serverId: $serverId, ')
          ..write('ownerId: $ownerId, ')
          ..write('titleEn: $titleEn, ')
          ..write('titleHi: $titleHi, ')
          ..write('descriptionEn: $descriptionEn, ')
          ..write('descriptionHi: $descriptionHi, ')
          ..write('category: $category, ')
          ..write('material: $material, ')
          ..write('technique: $technique, ')
          ..write('hoursOfWork: $hoursOfWork, ')
          ..write('materialCost: $materialCost, ')
          ..write('priceFloor: $priceFloor, ')
          ..write('price: $price, ')
          ..write('imagePaths: $imagePaths, ')
          ..write('remoteImageUrls: $remoteImageUrls, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    clientId,
    serverId,
    ownerId,
    titleEn,
    titleHi,
    descriptionEn,
    descriptionHi,
    category,
    material,
    technique,
    hoursOfWork,
    materialCost,
    priceFloor,
    price,
    imagePaths,
    remoteImageUrls,
    synced,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProduct &&
          other.clientId == this.clientId &&
          other.serverId == this.serverId &&
          other.ownerId == this.ownerId &&
          other.titleEn == this.titleEn &&
          other.titleHi == this.titleHi &&
          other.descriptionEn == this.descriptionEn &&
          other.descriptionHi == this.descriptionHi &&
          other.category == this.category &&
          other.material == this.material &&
          other.technique == this.technique &&
          other.hoursOfWork == this.hoursOfWork &&
          other.materialCost == this.materialCost &&
          other.priceFloor == this.priceFloor &&
          other.price == this.price &&
          other.imagePaths == this.imagePaths &&
          other.remoteImageUrls == this.remoteImageUrls &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt);
}

class LocalProductsCompanion extends UpdateCompanion<LocalProduct> {
  final Value<String> clientId;
  final Value<String?> serverId;
  final Value<String?> ownerId;
  final Value<String?> titleEn;
  final Value<String?> titleHi;
  final Value<String?> descriptionEn;
  final Value<String?> descriptionHi;
  final Value<String?> category;
  final Value<String?> material;
  final Value<String?> technique;
  final Value<double?> hoursOfWork;
  final Value<int?> materialCost;
  final Value<int?> priceFloor;
  final Value<int?> price;
  final Value<String> imagePaths;
  final Value<String> remoteImageUrls;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LocalProductsCompanion({
    this.clientId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.titleEn = const Value.absent(),
    this.titleHi = const Value.absent(),
    this.descriptionEn = const Value.absent(),
    this.descriptionHi = const Value.absent(),
    this.category = const Value.absent(),
    this.material = const Value.absent(),
    this.technique = const Value.absent(),
    this.hoursOfWork = const Value.absent(),
    this.materialCost = const Value.absent(),
    this.priceFloor = const Value.absent(),
    this.price = const Value.absent(),
    this.imagePaths = const Value.absent(),
    this.remoteImageUrls = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalProductsCompanion.insert({
    required String clientId,
    this.serverId = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.titleEn = const Value.absent(),
    this.titleHi = const Value.absent(),
    this.descriptionEn = const Value.absent(),
    this.descriptionHi = const Value.absent(),
    this.category = const Value.absent(),
    this.material = const Value.absent(),
    this.technique = const Value.absent(),
    this.hoursOfWork = const Value.absent(),
    this.materialCost = const Value.absent(),
    this.priceFloor = const Value.absent(),
    this.price = const Value.absent(),
    this.imagePaths = const Value.absent(),
    this.remoteImageUrls = const Value.absent(),
    this.synced = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : clientId = Value(clientId),
       createdAt = Value(createdAt);
  static Insertable<LocalProduct> custom({
    Expression<String>? clientId,
    Expression<String>? serverId,
    Expression<String>? ownerId,
    Expression<String>? titleEn,
    Expression<String>? titleHi,
    Expression<String>? descriptionEn,
    Expression<String>? descriptionHi,
    Expression<String>? category,
    Expression<String>? material,
    Expression<String>? technique,
    Expression<double>? hoursOfWork,
    Expression<int>? materialCost,
    Expression<int>? priceFloor,
    Expression<int>? price,
    Expression<String>? imagePaths,
    Expression<String>? remoteImageUrls,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientId != null) 'client_id': clientId,
      if (serverId != null) 'server_id': serverId,
      if (ownerId != null) 'owner_id': ownerId,
      if (titleEn != null) 'title_en': titleEn,
      if (titleHi != null) 'title_hi': titleHi,
      if (descriptionEn != null) 'description_en': descriptionEn,
      if (descriptionHi != null) 'description_hi': descriptionHi,
      if (category != null) 'category': category,
      if (material != null) 'material': material,
      if (technique != null) 'technique': technique,
      if (hoursOfWork != null) 'hours_of_work': hoursOfWork,
      if (materialCost != null) 'material_cost': materialCost,
      if (priceFloor != null) 'price_floor': priceFloor,
      if (price != null) 'price': price,
      if (imagePaths != null) 'image_paths': imagePaths,
      if (remoteImageUrls != null) 'remote_image_urls': remoteImageUrls,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalProductsCompanion copyWith({
    Value<String>? clientId,
    Value<String?>? serverId,
    Value<String?>? ownerId,
    Value<String?>? titleEn,
    Value<String?>? titleHi,
    Value<String?>? descriptionEn,
    Value<String?>? descriptionHi,
    Value<String?>? category,
    Value<String?>? material,
    Value<String?>? technique,
    Value<double?>? hoursOfWork,
    Value<int?>? materialCost,
    Value<int?>? priceFloor,
    Value<int?>? price,
    Value<String>? imagePaths,
    Value<String>? remoteImageUrls,
    Value<bool>? synced,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalProductsCompanion(
      clientId: clientId ?? this.clientId,
      serverId: serverId ?? this.serverId,
      ownerId: ownerId ?? this.ownerId,
      titleEn: titleEn ?? this.titleEn,
      titleHi: titleHi ?? this.titleHi,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionHi: descriptionHi ?? this.descriptionHi,
      category: category ?? this.category,
      material: material ?? this.material,
      technique: technique ?? this.technique,
      hoursOfWork: hoursOfWork ?? this.hoursOfWork,
      materialCost: materialCost ?? this.materialCost,
      priceFloor: priceFloor ?? this.priceFloor,
      price: price ?? this.price,
      imagePaths: imagePaths ?? this.imagePaths,
      remoteImageUrls: remoteImageUrls ?? this.remoteImageUrls,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (titleEn.present) {
      map['title_en'] = Variable<String>(titleEn.value);
    }
    if (titleHi.present) {
      map['title_hi'] = Variable<String>(titleHi.value);
    }
    if (descriptionEn.present) {
      map['description_en'] = Variable<String>(descriptionEn.value);
    }
    if (descriptionHi.present) {
      map['description_hi'] = Variable<String>(descriptionHi.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (material.present) {
      map['material'] = Variable<String>(material.value);
    }
    if (technique.present) {
      map['technique'] = Variable<String>(technique.value);
    }
    if (hoursOfWork.present) {
      map['hours_of_work'] = Variable<double>(hoursOfWork.value);
    }
    if (materialCost.present) {
      map['material_cost'] = Variable<int>(materialCost.value);
    }
    if (priceFloor.present) {
      map['price_floor'] = Variable<int>(priceFloor.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (imagePaths.present) {
      map['image_paths'] = Variable<String>(imagePaths.value);
    }
    if (remoteImageUrls.present) {
      map['remote_image_urls'] = Variable<String>(remoteImageUrls.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalProductsCompanion(')
          ..write('clientId: $clientId, ')
          ..write('serverId: $serverId, ')
          ..write('ownerId: $ownerId, ')
          ..write('titleEn: $titleEn, ')
          ..write('titleHi: $titleHi, ')
          ..write('descriptionEn: $descriptionEn, ')
          ..write('descriptionHi: $descriptionHi, ')
          ..write('category: $category, ')
          ..write('material: $material, ')
          ..write('technique: $technique, ')
          ..write('hoursOfWork: $hoursOfWork, ')
          ..write('materialCost: $materialCost, ')
          ..write('priceFloor: $priceFloor, ')
          ..write('price: $price, ')
          ..write('imagePaths: $imagePaths, ')
          ..write('remoteImageUrls: $remoteImageUrls, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$OutboxDb extends GeneratedDatabase {
  _$OutboxDb(QueryExecutor e) : super(e);
  $OutboxDbManager get managers => $OutboxDbManager(this);
  late final $OutboxEntriesTable outboxEntries = $OutboxEntriesTable(this);
  late final $LocalProductsTable localProducts = $LocalProductsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    outboxEntries,
    localProducts,
  ];
}

typedef $$OutboxEntriesTableCreateCompanionBuilder =
    OutboxEntriesCompanion Function({
      required String clientId,
      required String entity,
      required String op,
      required String payload,
      required DateTime createdAt,
      Value<int> attempts,
      Value<String?> lastError,
      Value<bool> sent,
      Value<int> rowid,
    });
typedef $$OutboxEntriesTableUpdateCompanionBuilder =
    OutboxEntriesCompanion Function({
      Value<String> clientId,
      Value<String> entity,
      Value<String> op,
      Value<String> payload,
      Value<DateTime> createdAt,
      Value<int> attempts,
      Value<String?> lastError,
      Value<bool> sent,
      Value<int> rowid,
    });

class $$OutboxEntriesTableFilterComposer
    extends Composer<_$OutboxDb, $OutboxEntriesTable> {
  $$OutboxEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sent => $composableBuilder(
    column: $table.sent,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxEntriesTableOrderingComposer
    extends Composer<_$OutboxDb, $OutboxEntriesTable> {
  $$OutboxEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sent => $composableBuilder(
    column: $table.sent,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxEntriesTableAnnotationComposer
    extends Composer<_$OutboxDb, $OutboxEntriesTable> {
  $$OutboxEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<bool> get sent =>
      $composableBuilder(column: $table.sent, builder: (column) => column);
}

class $$OutboxEntriesTableTableManager
    extends
        RootTableManager<
          _$OutboxDb,
          $OutboxEntriesTable,
          OutboxEntry,
          $$OutboxEntriesTableFilterComposer,
          $$OutboxEntriesTableOrderingComposer,
          $$OutboxEntriesTableAnnotationComposer,
          $$OutboxEntriesTableCreateCompanionBuilder,
          $$OutboxEntriesTableUpdateCompanionBuilder,
          (
            OutboxEntry,
            BaseReferences<_$OutboxDb, $OutboxEntriesTable, OutboxEntry>,
          ),
          OutboxEntry,
          PrefetchHooks Function()
        > {
  $$OutboxEntriesTableTableManager(_$OutboxDb db, $OutboxEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> clientId = const Value.absent(),
                Value<String> entity = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<bool> sent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxEntriesCompanion(
                clientId: clientId,
                entity: entity,
                op: op,
                payload: payload,
                createdAt: createdAt,
                attempts: attempts,
                lastError: lastError,
                sent: sent,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientId,
                required String entity,
                required String op,
                required String payload,
                required DateTime createdAt,
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<bool> sent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxEntriesCompanion.insert(
                clientId: clientId,
                entity: entity,
                op: op,
                payload: payload,
                createdAt: createdAt,
                attempts: attempts,
                lastError: lastError,
                sent: sent,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$OutboxDb,
      $OutboxEntriesTable,
      OutboxEntry,
      $$OutboxEntriesTableFilterComposer,
      $$OutboxEntriesTableOrderingComposer,
      $$OutboxEntriesTableAnnotationComposer,
      $$OutboxEntriesTableCreateCompanionBuilder,
      $$OutboxEntriesTableUpdateCompanionBuilder,
      (
        OutboxEntry,
        BaseReferences<_$OutboxDb, $OutboxEntriesTable, OutboxEntry>,
      ),
      OutboxEntry,
      PrefetchHooks Function()
    >;
typedef $$LocalProductsTableCreateCompanionBuilder =
    LocalProductsCompanion Function({
      required String clientId,
      Value<String?> serverId,
      Value<String?> ownerId,
      Value<String?> titleEn,
      Value<String?> titleHi,
      Value<String?> descriptionEn,
      Value<String?> descriptionHi,
      Value<String?> category,
      Value<String?> material,
      Value<String?> technique,
      Value<double?> hoursOfWork,
      Value<int?> materialCost,
      Value<int?> priceFloor,
      Value<int?> price,
      Value<String> imagePaths,
      Value<String> remoteImageUrls,
      Value<bool> synced,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$LocalProductsTableUpdateCompanionBuilder =
    LocalProductsCompanion Function({
      Value<String> clientId,
      Value<String?> serverId,
      Value<String?> ownerId,
      Value<String?> titleEn,
      Value<String?> titleHi,
      Value<String?> descriptionEn,
      Value<String?> descriptionHi,
      Value<String?> category,
      Value<String?> material,
      Value<String?> technique,
      Value<double?> hoursOfWork,
      Value<int?> materialCost,
      Value<int?> priceFloor,
      Value<int?> price,
      Value<String> imagePaths,
      Value<String> remoteImageUrls,
      Value<bool> synced,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$LocalProductsTableFilterComposer
    extends Composer<_$OutboxDb, $LocalProductsTable> {
  $$LocalProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleHi => $composableBuilder(
    column: $table.titleHi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionEn => $composableBuilder(
    column: $table.descriptionEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionHi => $composableBuilder(
    column: $table.descriptionHi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get material => $composableBuilder(
    column: $table.material,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get technique => $composableBuilder(
    column: $table.technique,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hoursOfWork => $composableBuilder(
    column: $table.hoursOfWork,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get materialCost => $composableBuilder(
    column: $table.materialCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceFloor => $composableBuilder(
    column: $table.priceFloor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePaths => $composableBuilder(
    column: $table.imagePaths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteImageUrls => $composableBuilder(
    column: $table.remoteImageUrls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalProductsTableOrderingComposer
    extends Composer<_$OutboxDb, $LocalProductsTable> {
  $$LocalProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleHi => $composableBuilder(
    column: $table.titleHi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionEn => $composableBuilder(
    column: $table.descriptionEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionHi => $composableBuilder(
    column: $table.descriptionHi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get material => $composableBuilder(
    column: $table.material,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get technique => $composableBuilder(
    column: $table.technique,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hoursOfWork => $composableBuilder(
    column: $table.hoursOfWork,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get materialCost => $composableBuilder(
    column: $table.materialCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceFloor => $composableBuilder(
    column: $table.priceFloor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePaths => $composableBuilder(
    column: $table.imagePaths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteImageUrls => $composableBuilder(
    column: $table.remoteImageUrls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalProductsTableAnnotationComposer
    extends Composer<_$OutboxDb, $LocalProductsTable> {
  $$LocalProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get titleEn =>
      $composableBuilder(column: $table.titleEn, builder: (column) => column);

  GeneratedColumn<String> get titleHi =>
      $composableBuilder(column: $table.titleHi, builder: (column) => column);

  GeneratedColumn<String> get descriptionEn => $composableBuilder(
    column: $table.descriptionEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descriptionHi => $composableBuilder(
    column: $table.descriptionHi,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get material =>
      $composableBuilder(column: $table.material, builder: (column) => column);

  GeneratedColumn<String> get technique =>
      $composableBuilder(column: $table.technique, builder: (column) => column);

  GeneratedColumn<double> get hoursOfWork => $composableBuilder(
    column: $table.hoursOfWork,
    builder: (column) => column,
  );

  GeneratedColumn<int> get materialCost => $composableBuilder(
    column: $table.materialCost,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priceFloor => $composableBuilder(
    column: $table.priceFloor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get imagePaths => $composableBuilder(
    column: $table.imagePaths,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remoteImageUrls => $composableBuilder(
    column: $table.remoteImageUrls,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalProductsTableTableManager
    extends
        RootTableManager<
          _$OutboxDb,
          $LocalProductsTable,
          LocalProduct,
          $$LocalProductsTableFilterComposer,
          $$LocalProductsTableOrderingComposer,
          $$LocalProductsTableAnnotationComposer,
          $$LocalProductsTableCreateCompanionBuilder,
          $$LocalProductsTableUpdateCompanionBuilder,
          (
            LocalProduct,
            BaseReferences<_$OutboxDb, $LocalProductsTable, LocalProduct>,
          ),
          LocalProduct,
          PrefetchHooks Function()
        > {
  $$LocalProductsTableTableManager(_$OutboxDb db, $LocalProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> clientId = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String?> ownerId = const Value.absent(),
                Value<String?> titleEn = const Value.absent(),
                Value<String?> titleHi = const Value.absent(),
                Value<String?> descriptionEn = const Value.absent(),
                Value<String?> descriptionHi = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> material = const Value.absent(),
                Value<String?> technique = const Value.absent(),
                Value<double?> hoursOfWork = const Value.absent(),
                Value<int?> materialCost = const Value.absent(),
                Value<int?> priceFloor = const Value.absent(),
                Value<int?> price = const Value.absent(),
                Value<String> imagePaths = const Value.absent(),
                Value<String> remoteImageUrls = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalProductsCompanion(
                clientId: clientId,
                serverId: serverId,
                ownerId: ownerId,
                titleEn: titleEn,
                titleHi: titleHi,
                descriptionEn: descriptionEn,
                descriptionHi: descriptionHi,
                category: category,
                material: material,
                technique: technique,
                hoursOfWork: hoursOfWork,
                materialCost: materialCost,
                priceFloor: priceFloor,
                price: price,
                imagePaths: imagePaths,
                remoteImageUrls: remoteImageUrls,
                synced: synced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientId,
                Value<String?> serverId = const Value.absent(),
                Value<String?> ownerId = const Value.absent(),
                Value<String?> titleEn = const Value.absent(),
                Value<String?> titleHi = const Value.absent(),
                Value<String?> descriptionEn = const Value.absent(),
                Value<String?> descriptionHi = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> material = const Value.absent(),
                Value<String?> technique = const Value.absent(),
                Value<double?> hoursOfWork = const Value.absent(),
                Value<int?> materialCost = const Value.absent(),
                Value<int?> priceFloor = const Value.absent(),
                Value<int?> price = const Value.absent(),
                Value<String> imagePaths = const Value.absent(),
                Value<String> remoteImageUrls = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalProductsCompanion.insert(
                clientId: clientId,
                serverId: serverId,
                ownerId: ownerId,
                titleEn: titleEn,
                titleHi: titleHi,
                descriptionEn: descriptionEn,
                descriptionHi: descriptionHi,
                category: category,
                material: material,
                technique: technique,
                hoursOfWork: hoursOfWork,
                materialCost: materialCost,
                priceFloor: priceFloor,
                price: price,
                imagePaths: imagePaths,
                remoteImageUrls: remoteImageUrls,
                synced: synced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$OutboxDb,
      $LocalProductsTable,
      LocalProduct,
      $$LocalProductsTableFilterComposer,
      $$LocalProductsTableOrderingComposer,
      $$LocalProductsTableAnnotationComposer,
      $$LocalProductsTableCreateCompanionBuilder,
      $$LocalProductsTableUpdateCompanionBuilder,
      (
        LocalProduct,
        BaseReferences<_$OutboxDb, $LocalProductsTable, LocalProduct>,
      ),
      LocalProduct,
      PrefetchHooks Function()
    >;

class $OutboxDbManager {
  final _$OutboxDb _db;
  $OutboxDbManager(this._db);
  $$OutboxEntriesTableTableManager get outboxEntries =>
      $$OutboxEntriesTableTableManager(_db, _db.outboxEntries);
  $$LocalProductsTableTableManager get localProducts =>
      $$LocalProductsTableTableManager(_db, _db.localProducts);
}

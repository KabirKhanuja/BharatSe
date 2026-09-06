/// What the app is currently able to do about the network.
///
/// Lives on its own so both the state layer and the widgets can depend on it
/// without importing each other.
enum LinkState { online, offline, syncing }

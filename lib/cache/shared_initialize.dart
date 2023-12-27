class SharedInitializeException implements Exception {
  @override
  String toString() {
    return 'Preferences has not been initialized right now';
  }
}

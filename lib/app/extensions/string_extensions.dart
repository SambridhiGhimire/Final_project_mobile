extension NullSafety on String? {
  String get orEmpty => this ?? '';
}

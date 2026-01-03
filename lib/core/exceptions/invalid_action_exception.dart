class InvalidActionException implements Exception {
  const InvalidActionException(this.message);
  final String message;

  @override
  String toString() => 'InvalidActionException: $message';
}

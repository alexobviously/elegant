/// Thrown when `Result.unwrap` is called on an `Err`.
class const UnwrapException<E>(
  /// The error contained by the result.
  final E error,
) implements Exception {
  @override
  String toString() => 'Tried to unwrap a Result that had an error: $error';
}

/// Thrown when `Result.unwrapError` is called on an `Ok`.
class const UnwrapErrorException<T>(
  /// The value contained by the result.
  final T value,
) implements Exception {
  @override
  String toString() => 'Tried to unwrap an error from an ok Result: $value';
}

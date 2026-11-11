import 'result.dart';

/// Operations on an iterable of [Result]s.
extension ResultIterableExtension<T, E> on Iterable<Result<T, E>> {
  /// The successful results, evaluated lazily.
  Iterable<Ok<T, E>> get oks => whereType<Ok<T, E>>();

  /// The failed results, evaluated lazily.
  Iterable<Err<T, E>> get errs => whereType<Err<T, E>>();

  /// Collects every successful value, or returns the first error.
  ///
  /// An empty iterable produces an [Ok] containing an empty list.
  Result<List<T>, E> sequence() {
    final values = <T>[];
    for (final result in this) {
      switch (result) {
        case Ok(:final value):
          values.add(value);
        case Err(:final error):
          return .error(error);
      }
    }
    return .ok(values);
  }
}

/// Operations on an iterable of successful results.
extension OkIterableExtension<T, E> on Iterable<Ok<T, E>> {
  /// The successful values, evaluated lazily.
  Iterable<T> get values => map((result) => result.value);
}

/// Operations on an iterable of failed results.
extension ErrIterableExtension<T, E> on Iterable<Err<T, E>> {
  /// The error values, evaluated lazily.
  Iterable<E> get values => map((result) => result.error);
}

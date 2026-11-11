import 'errors.dart';

/// The result of a computation that either succeeded with a [T] or failed
/// with an [E].
///
/// Use [Result.ok] and [Result.error] to create results, and pattern matching
/// to handle [Ok] and [Err] exhaustively.
sealed class const Result<T, E>() {
  /// A successful result containing [value].
  const factory ok(T value) = Ok<T, E>;

  /// A failed result containing [error].
  const factory error(E error) = Err<T, E>;

  /// Whether this result is an [Ok].
  bool get isOk => switch (this) {
    Ok() => true,
    Err() => false,
  };

  /// Whether this result is an [Err].
  bool get isErr => switch (this) {
    Ok() => false,
    Err() => true,
  };

  /// Transforms the value of an [Ok], preserving an [Err]'s error.
  Result<U, E> map<U>(U Function(T value) transform) => switch (this) {
    Ok(:final value) => .ok(transform(value)),
    Err(:final error) => .error(error),
  };

  /// Chains a computation returning another [Result] from an [Ok].
  ///
  /// An [Err] bypasses [transform] and preserves its error.
  Result<U, E> andThen<U>(Result<U, E> Function(T value) transform) =>
      switch (this) {
        Ok(:final value) => transform(value),
        Err(:final error) => .error(error),
      };

  /// Transforms the error of an [Err], preserving an [Ok]'s value.
  Result<T, F> mapError<F>(F Function(E error) transform) => switch (this) {
    Ok(:final value) => .ok(value),
    Err(:final error) => .error(transform(error)),
  };

  /// Handles both variants and returns a common result type.
  R fold<R>({
    required R Function(T value) onOk,
    required R Function(E error) onError,
  }) => switch (this) {
    Ok(:final value) => onOk(value),
    Err(:final error) => onError(error),
  };

  /// Returns the value of an [Ok].
  ///
  /// Throws an [UnwrapException] containing the error when this is an [Err].
  T unwrap() => switch (this) {
    Ok(:final value) => value,
    Err(:final error) => throw UnwrapException<E>(error),
  };

  /// Returns the error of an [Err].
  ///
  /// Throws an [UnwrapErrorException] containing the value when this is an
  /// [Ok].
  E unwrapError() => switch (this) {
    Ok(:final value) => throw UnwrapErrorException<T>(value),
    Err(:final error) => error,
  };

  /// Returns an [Ok]'s value or computes a fallback from an [Err]'s error.
  T unwrapOrElse(T Function(E error) fallback) => switch (this) {
    Ok(:final value) => value,
    Err(:final error) => fallback(error),
  };

  /// Returns an [Ok]'s value or `null` when this is an [Err].
  ///
  /// This intentionally cannot distinguish `Ok(null)` from an [Err].
  T? toNullable() => switch (this) {
    Ok(:final value) => value,
    Err() => null,
  };

  @Deprecated('Use isOk instead.')
  bool get ok => isOk;

  @Deprecated('Use isErr instead.')
  bool get hasError => isErr;

  @Deprecated('Use isOk instead.')
  bool get hasObject => isOk;

  @Deprecated('Pattern match on Ok and read value instead.')
  T? get object => switch (this) {
    Ok(:final value) => value,
    Err() => null,
  };

  @Deprecated('Pattern match on Err and read error instead.')
  E? get error;

  @Deprecated('Use andThen instead.')
  Result<U, E> transform<U>(Result<U, E> Function(T? value) transformer) =>
      andThen((value) => transformer(value));

  @Deprecated('Use map instead.')
  Result<U, E> transformOk<U>(U Function(T? value) transformer) =>
      map((value) => transformer(value));
}

/// A successful [Result] containing [value].
final class const Ok<T, E>(
  /// The successful value.
  final T value,
) extends Result<T, E> {
  @Deprecated('Pattern match on Err and read error instead.')
  @override
  E? get error => null;

  @override
  String toString() => 'Ok($value)';
}

/// A failed [Result] containing [error].
final class const Err<T, E>(
  /// The error value.
  @override final E error,
) extends Result<T, E> {
  @override
  String toString() => 'Err($error)';
}

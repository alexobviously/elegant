A utility package containing all the little functions and classes I find myself reusing frequently.
This will be expanded, documented and fit for general public use eventually, when I find the time.

## Result

`Result<T, E>` is a Rust-inspired sealed type for computations that either
succeed with a value or fail with an error:

```dart
Result<int, String> parseCount(String source) {
  final value = int.tryParse(source);
  return value == null
      ? Result.error('Not a number')
      : Result.ok(value);
}

final message = switch (parseCount('42')) {
  Ok(:final value) => 'Parsed $value',
  Err(:final error) => 'Failed: $error',
};
```

Results support `map`, `andThen`, `mapError`, `fold`, `unwrap`,
`unwrapError`, `unwrapOrElse`, and `toNullable`.
`Ok` and `Err` use value equality when their concrete types and payloads are
equal.

Iterables of results expose lazy `oks` and `errs` views. Their payloads are
available through `results.oks.values` and `results.errs.values`.
`results.sequence()` collects every successful value or returns the first
error.

The unnamed `Result` constructor was removed in 2.0. Existing
`Result.ok(...)` and `Result.error(...)` calls remain supported. The old
nullable getters and `transform` methods are deprecated in favor of pattern
matching and the new operations.
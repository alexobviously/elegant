### 1.0.0
- Bumped minimum Dart SDK version to 3.10.0, updated dependencies.
- `mapBy()` function for mapping iterables by a key function. Also accessible with the `Iterable.mapBy` extension function.

### 0.0.7
- `Iterable.firstAfter` and `Iterable.indexOf`.

### 0.0.6
- `circularList()` function for looping over lists infinitely. Also accessible with the `List.circular()` extension function.

### 0.0.5
- `groupBy()` function for grouping iterables by an arbitrary condition.
- `Iterable` extension methods: `groupBy`, `groups`, `pairs`.

### 0.0.4
- `Result.transform`'s `transformer` param can now take null values.
- `Result.transformOk`: like `transform`, but assumes the transformation result is always ok if the input is.

### 0.0.3
- `groups()` and `pairs()` functions for generating groups from iterables.

### 0.0.2
- `Result.unwrap()`: returns the result, or throws an exception.

### 0.0.1
- Initial version.

import 'iterables.dart' as it;

extension ElegantIterableExtension<T> on Iterable<T> {
  Iterable<X> pairs<X>(
    X Function(T a, T b) combine, {
    int step = 1,
  }) =>
      it.groups<T, X>(this, 2, (e) => combine(e[0], e[1]), step: step);

  Iterable<X> groups<X>(
    int groupSize,
    X Function(List<T> e) combine, {
    int step = 1,
  }) =>
      it.groups<T, X>(this, groupSize, combine, step: step);

  Iterable<List<T>> groupBy(bool Function(T prev, T next) condition) =>
      it.groupBy<T>(this, condition);

  Map<I, List<T>> mapBy<I>(I Function(T e) key) => it.mapBy<I, T>(this, key);

  T? firstAfter(T value) => skipWhile((e) => e != value).skip(1).firstOrNull;

  int indexOf(T value) {
    int i = 0;
    for (final x in this) {
      if (x == value) {
        return i;
      }
      i++;
    }
    return -1;
  }
}

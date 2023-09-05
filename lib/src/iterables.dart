import 'dart:collection';
import 'dart:math';

Iterable<X> pairs<T, X>(
  Iterable<T> items,
  X Function(T a, T b) combine, {
  int step = 1,
}) =>
    groups(items, 2, (e) => combine(e[0], e[1]), step: step);

Iterable<X> groups<T, X>(
  Iterable<T> items,
  int groupSize,
  X Function(List<T> e) combine, {
  int step = 1,
}) sync* {
  Queue<T> queue = Queue();
  final it = items.iterator;
  while (it.moveNext()) {
    queue.add(it.current);
    if (queue.length >= groupSize) {
      yield combine(queue.take(groupSize).toList(growable: false));
      for (final _ in Iterable.generate(min(queue.length, step))) {
        queue.removeFirst();
      }
      if (step > groupSize) {
        for (final _ in Iterable.generate(step - groupSize)) {
          it.moveNext();
        }
      }
    }
  }
}

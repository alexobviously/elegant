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

Iterable<List<T>> groupBy<T>(
  Iterable<T> items,
  bool Function(T prev, T next) condition,
) sync* {
  final it = items.iterator;
  List<T> group = [];
  while (it.moveNext()) {
    if (group.isEmpty) {
      group.add(it.current);
      continue;
    }
    if (condition(group.last, it.current)) {
      group.add(it.current);
    } else {
      yield group;
      group = [it.current];
    }
  }
  if (group.isNotEmpty) {
    yield group;
  }
}

Iterable<T> circularList<T>(List<T> items, {int step = 1}) sync* {
  int i = 0;
  while (true) {
    yield items[i % items.length];
    i += step;
  }
}

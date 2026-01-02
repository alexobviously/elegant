import 'package:elegant/elegant.dart';
import 'package:test/test.dart';

void main() {
  group('Iterables', () {
    test('Circular List', () {
      final items = [1, 2, 3];
      expect(circularList(items).take(8), [1, 2, 3, 1, 2, 3, 1, 2]);
    });

    test('Map By', () {
      final items = <(int, String)>[
        (1, 'a'),
        (2, 'b'),
        (1, 'c'),
        (1, 'd'),
        (2, 'e')
      ];
      final map = mapBy(items, (e) => e.$1);
      expect(map, {
        1: [(1, 'a'), (1, 'c'), (1, 'd')],
        2: [(2, 'b'), (2, 'e')]
      });
    });
  });
}

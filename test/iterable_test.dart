import 'package:elegant/elegant.dart';
import 'package:test/test.dart';

void main() {
  group('Iterables', () {
    test('Circular List', () {
      final items = [1, 2, 3];
      expect(circularList(items).take(8), [1, 2, 3, 1, 2, 3, 1, 2]);
    });
  });
}

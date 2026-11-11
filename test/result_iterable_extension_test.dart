import 'package:elegant/elegant.dart';
import 'package:test/test.dart';

void main() {
  group('result variants', () {
    test('oks and errs lazily retain their matching variants', () {
      var yielded = 0;
      Iterable<Result<int, String>> results() sync* {
        yielded++;
        yield const .ok(1);
        yielded++;
        yield const .error('first');
        yielded++;
        yield const .ok(2);
        yielded++;
        yield const .error('second');
      }

      final oks = results().oks;
      final errs = results().errs;

      expect(yielded, 0);
      expect(oks, everyElement(isA<Ok<int, String>>()));
      expect(yielded, 4);
      expect(errs, everyElement(isA<Err<int, String>>()));
      expect(yielded, 8);
    });

    test('values lazily extracts Ok and Err payloads', () {
      final results = <Result<int, String>>[
        const .ok(1),
        const .error('first'),
        const .ok(2),
        const .error('second'),
      ];

      expect(results.oks.values, [1, 2]);
      expect(results.errs.values, ['first', 'second']);
    });

    test('values preserves nullable payloads', () {
      final results = <Result<int?, String?>>[
        const .ok(null),
        const .error(null),
      ];

      expect(results.oks.values, [null]);
      expect(results.errs.values, [null]);
    });
  });

  group('sequence', () {
    test('collects every Ok value in order', () {
      final results = <Result<int, String>>[
        const .ok(1),
        const .ok(2),
        const .ok(3),
      ];

      final sequenced = results.sequence();

      expect(sequenced, isA<Ok<List<int>, String>>());
      expect((sequenced as Ok<List<int>, String>).value, [1, 2, 3]);
    });

    test('returns the first Err without evaluating later results', () {
      var evaluatedAfterError = false;
      Iterable<Result<int, String>> results() sync* {
        yield const .ok(1);
        yield const .error('first');
        evaluatedAfterError = true;
        yield const .error('second');
      }

      final sequenced = results().sequence();

      expect(sequenced, isA<Err<List<int>, String>>());
      expect((sequenced as Err<List<int>, String>).error, 'first');
      expect(evaluatedAfterError, isFalse);
    });

    test('returns an empty Ok for an empty iterable', () {
      final sequenced = <Result<int, String>>[].sequence();

      expect(sequenced, isA<Ok<List<int>, String>>());
      expect((sequenced as Ok<List<int>, String>).value, isEmpty);
    });

    test('preserves nullable values and errors', () {
      final successful = <Result<int?, String?>>[const .ok(null)].sequence();
      final failed = <Result<int?, String?>>[const .error(null)].sequence();

      expect((successful as Ok<List<int?>, String?>).value, [null]);
      expect((failed as Err<List<int?>, String?>).error, isNull);
    });
  });
}

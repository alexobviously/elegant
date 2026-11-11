// ignore_for_file: deprecated_member_use_from_same_package

import 'package:elegant/elegant.dart';
import 'package:test/test.dart';

final class _Failure {
  const _Failure(this.message);

  final String message;

  @override
  String toString() => message;
}

void main() {
  group('construction and matching', () {
    test('Result.ok creates an Ok with a non-nullable value', () {
      const Result<int, _Failure> result = Result.ok(42);

      expect(result, isA<Ok<int, _Failure>>());
      expect((result as Ok<int, _Failure>).value, 42);
      expect(result.isOk, isTrue);
      expect(result.isErr, isFalse);
    });

    test('Result.error creates an Err with a non-nullable error', () {
      const failure = _Failure('failed');
      const Result<int, _Failure> result = Result.error(failure);

      expect(result, isA<Err<int, _Failure>>());
      expect((result as Err<int, _Failure>).error, same(failure));
      expect(result.isOk, isFalse);
      expect(result.isErr, isTrue);
    });

    test('nullable success values remain distinguishable from errors', () {
      const Result<String?, _Failure> result = Result.ok(null);

      expect(result, isA<Ok<String?, _Failure>>());
      expect((result as Ok<String?, _Failure>).value, isNull);
      expect(result.isOk, isTrue);
    });

    test('nullable error values remain distinguishable from successes', () {
      const Result<String, _Failure?> result = Result.error(null);

      expect(result, isA<Err<String, _Failure?>>());
      expect((result as Err<String, _Failure?>).error, isNull);
      expect(result.isErr, isTrue);
    });

    test('switch expressions exhaustively distinguish Ok and Err', () {
      String describe(Result<int, _Failure> result) => switch (result) {
        Ok(:final value) => 'ok: $value',
        Err(:final error) => 'error: ${error.message}',
      };

      expect(describe(const Result.ok(42)), 'ok: 42');
      expect(describe(const Result.error(_Failure('failed'))), 'error: failed');
    });
  });

  group('transformations', () {
    test('map transforms Ok', () {
      const result = Result<int, _Failure>.ok(21);

      final mapped = result.map((value) => value * 2);

      expect(mapped, isA<Ok<int, _Failure>>());
      expect((mapped as Ok<int, _Failure>).value, 42);
    });

    test('map preserves Err without invoking the transform', () {
      const failure = _Failure('failed');
      const result = Result<int, _Failure>.error(failure);

      final mapped = result.map<String>((_) {
        fail('map must not transform an Err');
      });

      expect(mapped, isA<Err<String, _Failure>>());
      expect((mapped as Err<String, _Failure>).error, same(failure));
    });

    test('andThen chains Ok', () {
      const result = Result<int, _Failure>.ok(21);

      final chained = result.andThen(
        (value) => Result<String, _Failure>.ok('${value * 2}'),
      );

      expect(chained, isA<Ok<String, _Failure>>());
      expect((chained as Ok<String, _Failure>).value, '42');
    });

    test('andThen preserves Err without invoking the transform', () {
      const failure = _Failure('failed');
      const result = Result<int, _Failure>.error(failure);

      final chained = result.andThen<String>((_) {
        fail('andThen must not transform an Err');
      });

      expect(chained, isA<Err<String, _Failure>>());
      expect((chained as Err<String, _Failure>).error, same(failure));
    });

    test('mapError transforms Err', () {
      const result = Result<int, _Failure>.error(_Failure('failed'));

      final mapped = result.mapError((error) => error.message);

      expect(mapped, isA<Err<int, String>>());
      expect((mapped as Err<int, String>).error, 'failed');
    });

    test('mapError preserves Ok without invoking the transform', () {
      const result = Result<int, _Failure>.ok(42);

      final mapped = result.mapError<String>((_) {
        fail('mapError must not transform an Ok');
      });

      expect(mapped, isA<Ok<int, String>>());
      expect((mapped as Ok<int, String>).value, 42);
    });
  });

  group('consumption', () {
    test('fold invokes only onOk for Ok', () {
      var okCalls = 0;
      var errorCalls = 0;

      final folded = const Result<int, _Failure>.ok(42).fold(
        onOk: (value) {
          okCalls++;
          return '$value';
        },
        onError: (_) {
          errorCalls++;
          return 'error';
        },
      );

      expect(folded, '42');
      expect(okCalls, 1);
      expect(errorCalls, 0);
    });

    test('fold invokes only onError for Err', () {
      var okCalls = 0;
      var errorCalls = 0;

      final folded = const Result<int, _Failure>.error(_Failure('failed')).fold(
        onOk: (value) {
          okCalls++;
          return '$value';
        },
        onError: (error) {
          errorCalls++;
          return error.message;
        },
      );

      expect(folded, 'failed');
      expect(okCalls, 0);
      expect(errorCalls, 1);
    });

    test('unwrap returns Ok values, including null', () {
      expect(const Result<int, _Failure>.ok(42).unwrap(), 42);
      expect(const Result<int?, _Failure>.ok(null).unwrap(), isNull);
    });

    test('unwrap throws an Exception containing the Err value', () {
      const failure = _Failure('failed');
      const result = Result<int, _Failure>.error(failure);

      expect(
        result.unwrap,
        throwsA(
          isA<UnwrapException<_Failure>>()
              .having((exception) => exception.error, 'error', same(failure))
              .having(
                (exception) => exception.toString(),
                'message',
                contains('failed'),
              ),
        ),
      );
    });

    test('unwrapError returns Err values, including null', () {
      const failure = _Failure('failed');

      expect(
        const Result<int, _Failure>.error(failure).unwrapError(),
        same(failure),
      );
      expect(const Result<int, _Failure?>.error(null).unwrapError(), isNull);
    });

    test('unwrapError throws an Exception containing the Ok value', () {
      const result = Result<int, _Failure>.ok(42);

      expect(
        result.unwrapError,
        throwsA(
          isA<UnwrapErrorException<int>>()
              .having((exception) => exception.value, 'value', 42)
              .having(
                (exception) => exception.toString(),
                'message',
                contains('42'),
              ),
        ),
      );
    });

    test('unwrapOrElse returns Ok without invoking the fallback', () {
      final value = const Result<int, _Failure>.ok(42).unwrapOrElse((_) {
        fail('unwrapOrElse must not compute a fallback for Ok');
      });

      expect(value, 42);
    });

    test('unwrapOrElse computes a fallback for Err', () {
      final value = const Result<int, _Failure>.error(
        _Failure('failed'),
      ).unwrapOrElse((error) => error.message.length);

      expect(value, 6);
    });

    test('toNullable returns Ok values and null for Err', () {
      expect(const Result<int, _Failure>.ok(42).toNullable(), 42);
      expect(
        const Result<int, _Failure>.error(_Failure('failed')).toNullable(),
        isNull,
      );
      expect(const Result<int?, _Failure>.ok(null).toNullable(), isNull);
    });
  });

  group('legacy compatibility', () {
    test('legacy getters reflect the variant', () {
      const Result<int?, _Failure> ok = Result.ok(null);
      const failure = _Failure('failed');
      const Result<int?, _Failure> err = Result.error(failure);

      expect(ok.ok, isTrue);
      expect(ok.hasError, isFalse);
      expect(ok.hasObject, isTrue);
      expect(ok.object, isNull);
      expect(ok.error, isNull);

      expect(err.ok, isFalse);
      expect(err.hasError, isTrue);
      expect(err.hasObject, isFalse);
      expect(err.object, isNull);
      expect(err.error, same(failure));
    });

    test('transform delegates to andThen', () {
      const result = Result<int?, _Failure>.ok(null);

      final transformed = result.transform(
        (value) => Result<String, _Failure>.ok('${value ?? 42}'),
      );

      expect((transformed as Ok<String, _Failure>).value, '42');
    });

    test('transformOk delegates to map', () {
      const result = Result<int?, _Failure>.ok(null);

      final transformed = result.transformOk((value) => value ?? 42);

      expect((transformed as Ok<int, _Failure>).value, 42);
    });
  });

  group('object behavior', () {
    test('variants use identity equality', () {
      final firstOk = Result<int, _Failure>.ok(42);
      final secondOk = Result<int, _Failure>.ok(42);
      final failure = _Failure('failed');
      final firstErr = Result<int, _Failure>.error(failure);
      final secondErr = Result<int, _Failure>.error(failure);

      expect(firstOk == secondOk, isFalse);
      expect(firstErr == secondErr, isFalse);
      expect(firstOk, same(firstOk));
      expect(firstErr, same(firstErr));
    });

    test('toString identifies the variant and payload', () {
      expect(const Result<int, _Failure>.ok(42).toString(), 'Ok(42)');
      expect(
        const Result<int, _Failure>.error(_Failure('failed')).toString(),
        'Err(failed)',
      );
    });
  });
}

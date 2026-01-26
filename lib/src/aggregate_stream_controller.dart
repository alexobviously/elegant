import 'dart:async';

/// Aggregates the output of multiple streams of the same type,
/// and combines them into a single [stream].
class AggregateStreamController<T> {
  final _controller = StreamController<T>.broadcast();

  Stream<T> get stream => _controller.stream;

  final _taggedSubs = <String, StreamSubscription<T>>{};
  final _untaggedSubs = <StreamSubscription<T>>[];

  /// Adds a stream and starts listening to it.
  /// If a [tag] is provided, it is possible to remove the stream later by
  /// calling [remove] with the same tag.
  void add(Stream<T> stream, [String? tag]) {
    // ignore: cancel_subscriptions
    final sub = stream.listen(_controller.add);
    if (tag != null) {
      _taggedSubs[tag] = sub;
    } else {
      _untaggedSubs.add(sub);
    }
  }

  /// Removes a stream that was added with a tag.
  /// Returns `true` if the stream was removed, `false` if it was not found.
  bool remove(String tag) {
    _taggedSubs[tag]?.cancel();
    return _taggedSubs.remove(tag) != null;
  }

  Future<void> close() async {
    for (final sub in _taggedSubs.values) {
      await sub.cancel();
    }
    for (final sub in _untaggedSubs) {
      await sub.cancel();
    }
    await _controller.close();
  }
}

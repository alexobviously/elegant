class UnwrapException<E> {
  final E? error;
  const UnwrapException([this.error]);

  @override
  String toString() => 'Tried to unwrap a Result that had an error: $error';
}

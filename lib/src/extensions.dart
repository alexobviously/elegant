extension AsType on Object {
  T? asType<T>() => this is T ? this as T : null;
}

// extension Transform<T> on T {
//   X transformIf<X>(bool condition, X Function(T e) transform) =>
//       condition ? transform(this) : this as X;
// }

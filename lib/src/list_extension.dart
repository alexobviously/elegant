import 'package:elegant/elegant.dart';

extension ElegantListExtension<T> on List<T> {
  Iterable<T> circular({int step = 1}) => circularList(this, step: step);
}

import 'dart:async';
import 'bloc.dart';

class DetailQuantityBloc extends Bloc {
  int _count = 1;
  int get selectedMenu => _count;
  // 1
  final _countController = StreamController<int>();
  // 2
  Stream<int> get countStream => _countController.stream;
  // 3
  void setCount(int count) {
    _count = count;
    _countController.sink.add(count);
  }

  // 4
  @override
  void dispose() {
    _countController.close();
  }
}

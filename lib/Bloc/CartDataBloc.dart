import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:ritakwaterapp/DataLayer/Cart.dart';
import 'package:ritakwaterapp/helpers/DBHelper.dart';

import '../shared_data.dart';
import 'bloc.dart';

class CartDataBloc implements Bloc {
  final _controller = StreamController<List<Cart>>();
  Stream<List<Cart>> get cartDataStream => _controller.stream;
  Future<void> fetchCartData() async {
    print("hoooooooos");
    final dataList = await DBHelper.getData('user_cart', sql_cart_query);
    List<Cart> items = dataList.map((item) {
      print(item['key']);
      return Cart(
        quantity: item['quantity'],
        productId: item['id'],
      );
    }).toList();
    counter = items.length;
    _controller.sink.add(items);
  }

  @override
  void dispose() {
    _controller.close();
  }
}

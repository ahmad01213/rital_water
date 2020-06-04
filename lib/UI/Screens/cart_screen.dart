import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ritakwaterapp/Bloc/CartDataBloc.dart';
import 'package:ritakwaterapp/Bloc/bloc_provider.dart';
import 'package:ritakwaterapp/Bloc/tab_bar_bloc.dart';
import 'package:ritakwaterapp/DataLayer/Cart.dart';
import 'package:ritakwaterapp/DataLayer/product.dart';
import 'package:ritakwaterapp/helpers/DBHelper.dart';
import 'package:ritakwaterapp/shared_data.dart';
import 'location_screen.dart';
import 'main_page.dart';

class CartScreen extends StatelessWidget {
  BuildContext context;
  double totalCost = 0.0;
  int totalCount = 0;
  List<Cart> carts;

  CartScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text(
          "سلة المشتريات",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: buildCartList(),
    );
  }

  Widget buildBottomView(List<Cart> data, context, CartDataBloc bloc) {
    if (data != null) {
      for (int i = 0; i < data.length; i++) {
        try {
          Product product =
              products.firstWhere((product) => data[i].productId == product.id);
          final cost = data[i].quantity * double.parse(product.price);
          totalCost = totalCost + cost;
          totalCount += data[i].quantity;
        } catch (e) {
          DBHelper.clearCart();
          bloc.fetchCartData();
        }
      }
    }
    return Container(
      margin: EdgeInsets.fromLTRB(10, 30, 10, 20),
      width: double.infinity,
      height: 100,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 10),
              child: Text('السعر  :  $totalCost  ريال',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ))),
          Container(
            child: footer(context, bloc),
            height: 60,
            width: double.infinity,
          )
        ],
      ),
    );
  }

  Widget footer(context, bloc) => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: mainColor, style: BorderStyle.solid, width: 1)),
                child: MaterialButton(
                  child: Text(
                    'أضف المزيد',
                    style: TextStyle(
                        color: mainColor, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    tabBloc.setCount(0);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                color: mainColor,
                child: MaterialButton(
                  child: Text(
                    'تنفيذ الطلب',
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (totalCount >= 10) {
                      if (isRegistered()) {
                        var cartsJsob = Cart.encondeToJson(carts);
                        print("mmmmmmmm : $cartsJsob");
                        goToConfirm(cartsJsob, bloc, context);
                      } else {
                        tabBloc.setCount(3);
                      }
                    } else {
                      alert(' الحد الأدني للطلب 10  كرتون', context);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      );

  alert(message, ctx) {
    showDialog(
        context: ctx,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              message,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  "حسنا",
                  style: TextStyle(
                      color: mainColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget buildCartListItem(Cart cart, bloc, context) {
    Product product;
    try {
      product = products.firstWhere((product) => cart.productId == product.id);
    } catch (e) {
      DBHelper.clearCart();
      bloc.fetchCartData();
    }

    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
      height: 180,
      width: MediaQuery.of(context).size.width,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            side: new BorderSide(color: mainColor, width: 0.5),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: double.infinity,
                width: 150,
                padding: EdgeInsets.all(10),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                        imageUrl: product.image, fit: BoxFit.fill)),
              ),
              Container(
                color: mainColor,
                height: double.infinity,
                width: 1,
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(15),
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              product.name,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                            width: 100,
                            height: 50,
                          ),
                          Container(
                            height: 25,
                            width: 25,
                            child: FlatButton(
                              child: Icon(
                                Icons.close,
                                size: 25,
                                color: mainColor,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onPressed: () {
                                DBHelper.delete('user_cart', cart.productId,
                                    sql_cart_query);
                                bloc.fetchCartData();
                              },
                              padding: EdgeInsets.all(0),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Text(
                        "${product.price}   ريال",
                        style: TextStyle(
                            color: mainColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ///minus
                                Container(
                                    height: 30,
                                    width: 30,
                                    child: ConstrainedBox(
                                        constraints: BoxConstraints.expand(),
                                        child: FlatButton(
                                            onPressed: () {
                                              DBHelper.update(
                                                  'user_cart',
                                                  cart.productId,
                                                  cart.quantity > 1
                                                      ? cart.quantity - 1
                                                      : 1,
                                                  sql_cart_query);
                                              bloc.fetchCartData();
                                            },
                                            padding: EdgeInsets.all(0.0),
                                            child: Image.asset(
                                              'assets/images/minus.png',
                                              fit: BoxFit.fill,
                                            )))),
                                Container(
                                    height: 30,
                                    width: 40,
                                    child: Center(
                                        child: Text(
                                      cart.quantity.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ))),

                                ///plus
                                Container(
                                    height: 30,
                                    width: 30,
                                    child: ConstrainedBox(
                                        constraints: BoxConstraints.expand(),
                                        child: FlatButton(
                                            onPressed: () {
                                              DBHelper.update(
                                                  'user_cart',
                                                  cart.productId,
                                                  cart.quantity + 1,
                                                  sql_cart_query);
                                              bloc.fetchCartData();
                                            },
                                            padding: EdgeInsets.all(0.0),
                                            child: Image.asset(
                                                'assets/images/plus.png',
                                                fit: BoxFit.fill)))),
                              ],
                            ),
                            width: 120,
                            height: 40,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Cart> data;

  Widget buildCartList() {
    final bloc = CartDataBloc();
    bloc.fetchCartData();
    return BlocProvider(
      bloc: bloc,
      child: StreamBuilder<List<Cart>>(
          stream: bloc.cartDataStream,
          builder: (context, snapshot) {
            data = snapshot.data;
            carts = snapshot.data;
            if (data != null) {
              totalCost = 0.0;
              totalCount = 0;
            }
            return carts != null && carts.length > 0
                ? ListView.builder(
                    itemCount: data == null ? 0 : data.length + 1,
                    itemBuilder: (ctx, i) {
                      print('total stream $totalCost');
                      return i == data.length
                          ? buildBottomView(data, context, bloc)
                          : buildCartListItem(data[i], bloc, context);
                    })
                : Center(
                    child: Text(
                      'السلة فارغة',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  );
          }),
    );
  }

  void goToConfirm(cartsJsob, CartDataBloc bloc, ctx) async {
    final resault = await Navigator.push(
        ctx,
        MaterialPageRoute(
          builder: (ctx) => ConfiremOrderScreen(
            carts: cartsJsob,
            totalCost: totalCost.toString(),
          ),
        ));
//    bloc.fetchCartData();
    if (resault == "yes") tabBloc.setCount(2);
  }
}

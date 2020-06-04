import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ritakwaterapp/Bloc/DetailQuantityBloc.dart';
import 'package:ritakwaterapp/Bloc/bloc_provider.dart';
import 'package:ritakwaterapp/DataLayer/Cart.dart';
import 'package:ritakwaterapp/DataLayer/product.dart';
import 'package:ritakwaterapp/helpers/DBHelper.dart';
import 'package:ritakwaterapp/shared_data.dart';

import 'location_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  Product product;

  ProductDetailsScreen(this.product);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final bloc = DetailQuantityBloc();

  int count = 1;

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 20, 20),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      FontAwesomeIcons.timesCircle,
                      size: 30,
                      color: mainColor,
                    ),
                  ),
                ),
              ),
              Container(
                height: 250,
                width: 200,
                padding: EdgeInsets.all(10),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                        imageUrl: widget.product.image, fit: BoxFit.fill)),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.product.name,
                style: TextStyle(
                    color: mainColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.product.desc,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "السعر  :  ${int.parse(widget.product.price) * count}  ريال",
                style: TextStyle(
                    color: mainColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    margin: EdgeInsets.symmetric(vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ///plus
                        Container(
                            height: 40,
                            width: 40,
                            child: ConstrainedBox(
                                constraints: BoxConstraints.expand(),
                                child: FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        count = count + 1;
                                      });

                                      bloc.setCount(count);
                                    },
                                    padding: EdgeInsets.all(0.0),
                                    child: Image.asset('assets/images/plus.png',
                                        fit: BoxFit.fill)))),
                        Text(
                          count.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),

                        ///minus
                        Container(
                            height: 40,
                            width: 40,
                            child: ConstrainedBox(
                                constraints: BoxConstraints.expand(),
                                child: FlatButton(
                                    onPressed: () {
                                      if (count > 1) {
                                        setState(() {
                                          count = count - 1;
                                        });
                                      }
                                    },
                                    padding: EdgeInsets.all(0.0),
                                    child: Image.asset(
                                      'assets/images/minus.png',
                                      fit: BoxFit.fill,
                                    )))),
                      ],
                    ),
                  ),
                ],
              ),
              footer(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget footer(context) => Container(
        width: MediaQuery.of(context).size.width,
        height: 70,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: mainColor,
                          style: BorderStyle.solid,
                          width: 1)),
                  child: MaterialButton(
                    child: Text(
                      'أضف إلي السلة',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      addProductToCart(count, widget.product.id, context);
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
                      'اطلب الان',
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (count >= 10) {
                        if (isRegistered()) {
                          String totalCost =
                              (count * int.parse(widget.product.price))
                                  .toString();
                          List<Cart> carts = [
                            Cart(productId: widget.product.id, quantity: count)
                          ];
                          String cartJson =
                              Cart.encondeToJson(carts).toString();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ConfiremOrderScreen(
                                totalCost: totalCost,
                                carts: cartJson,
                              ),
                            ),
                          );
                        } else {
                          tabBloc.setCount(3);
                          Navigator.of(context).pop();
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
        ),
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

  void showSnackBar(message) {
    scaffoldKey?.currentState?.showSnackBar(SnackBar(
      duration: Duration(seconds: 2),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
    ));
  }

  void addProductToCart(quantity, product_id, context) {
    DBHelper.database(sql_cart_query);
    DBHelper.insert(
        'user_cart',
        {
          'id': product_id,
          'quantity': quantity,
        },
        sql_cart_query);
    showSnackBar("تمت الإضافة إلي سلة المشتريات");
    Future.delayed(const Duration(milliseconds: 2500), () {
      Navigator.of(context).pop();
    });
  }
}

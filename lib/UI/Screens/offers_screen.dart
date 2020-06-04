import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ritakwaterapp/Bloc/bloc_provider.dart';
import 'package:ritakwaterapp/DataLayer/product.dart';
import 'package:ritakwaterapp/helpers/DBHelper.dart';

import '../../shared_data.dart';

class OffersScreen extends StatelessWidget {
  List<Product> offersList =
      products.where((product) => product.productType == "offer").toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text(
          "عروض ريتال",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: buildOffersList(context),
    );
  }

  Widget buildCartListItem(Product offer, context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
      height: 190,
      width: MediaQuery.of(context).size.width,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          side: new BorderSide(color: mainColor, width: 0.5),
        ),
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
                        imageUrl: offer.image, fit: BoxFit.fill)),
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
                              offer.name,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                            width: 100,
                            height: 50,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Text(
                        "${offer.price}   ريال",
                        style: TextStyle(
                            color: mainColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                                color: mainColor,
                                style: BorderStyle.solid,
                                width: 1)),
                        child: MaterialButton(
                          child: Text(
                            'أضف إلي السلة',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            addProductToCart(1, offer.id, context);
                          },
                        ),
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

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
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
//      Navigator.of(context).pop();
    });
  }

  Widget buildOffersList(context) {
    return ListView.builder(
        itemCount: offersList.length,
        itemBuilder: (ctx, i) {
          return buildCartListItem(offersList[i], context);
        });
  }
}

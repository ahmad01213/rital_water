import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ritakwaterapp/DataLayer/product.dart';
import '../../shared_data.dart';

class ProductItem extends StatelessWidget {
  Product product;
  ProductItem({this.product});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
      height: MediaQuery.of(context).size.height - 400,
      width: 200,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: new BorderSide(color: mainColor, width: 0.5),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10, 10, 10),
              child: Container(
                child: Text(
                  product.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 10),
              child: Container(
                child: Text(
                  product.price + "  ريال",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                ),
              ),
            ),
            Container(
              color: mainColor,
              width: double.infinity,
              height: 0.33,
            ),
            Flexible(
              child: Container(
                width: 150,
                height: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                        imageUrl: product.image, fit: BoxFit.fill)),
              ),
            ),
            divider(),
          ],
        ),
      ),
    );
  }

  Widget divider() {
    return Divider(
      indent: 20,
      endIndent: 20,
      height: 1,
      color: Colors.green,
    );
  }
}

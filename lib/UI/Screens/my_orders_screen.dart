import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ritakwaterapp/DataLayer/Order.dart';
import 'package:http/http.dart' as http;

import '../../shared_data.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  List<Order> orders = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          "طلباتي",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isRegistered()
          ? isloading
              ? Center(
                  child: Container(
                    child: SpinKitRing(
                      duration: Duration(milliseconds: 500),
                      color: mainColor,
                      size: 40,
                      lineWidth: 5,
                    ),
                    width: 100,
                    height: 100,
                  ),
                )
              : Center(
                  child: Container(
                      height: MediaQuery.of(context).size.height - 140,
                      child: orders.length > 0
                          ? buildList()
                          : Center(
                              child: Text(
                                "لا توجد لديك طلبات",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            )))
          : Center(
              child: Text(
                'الرجاء تسجيل الدخول',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }

  Widget buildList() {
    return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (ctx, i) {
          return buildListItem(orders[i]);
        });
  }

  Widget buildListItem(Order order) {
    return Container(
      height: 180,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 1.0,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 100,
                    child: Text(
                      "رقم الطلب",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Text(order.id,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 100,
                    child: Text(
                      "إجمالي السعر",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Text(
                    order.totalCost + "  R.S",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 100,
                    child: Text(
                      "تاريخ الطلب",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Container(
                    width: 100,
                    child: Text(
                      order.date,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget DataRow(name, value) {
    return Row(
      children: <Widget>[],
    );
  }

  bool isloading = false;
  getOrders() async {
    final url = 'http://thegradiant.com/rital_water/rital_water/api/userorders';
    final headers = {"Authorization": "Bearer " + token};
    print("url  :  $url");
    setState(() {
      isloading = true;
    });
    final response = await http.post(url, headers: headers);
    print("ressss : ${response.body}");
    final ordersJson = json.decode(response.body) as List<dynamic>;
    ordersJson.forEach((order) {
      final orderData = Order(
          id: order['id'].toString(),
          date: order['created_at'].toString().substring(0, 10),
          totalCost: order['total_cost']);
      orders.add(orderData);
    });
    orders = orders.reversed.toList();
    setState(() {
      isloading = false;
    });
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ritakwaterapp/DataLayer/Notification.dart';
import 'package:http/http.dart' as http;

import '../../shared_data.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel> notifications = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrders();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: Text(
          "الاشعارات",
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
                      child: notifications.length > 0
                          ? buildList()
                          : Center(
                              child: Text(
                                "لا توجد لديك اشعارات",
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
        itemCount: notifications.length,
        itemBuilder: (ctx, i) {
          return buildListItem(notifications[i]);
        });
  }

  Widget buildListItem(NotificationModel notification) {
    return Container(
      height: 150,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 1.0,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(1.0))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      notification.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    height: 35,
                    width: 35,
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        deleteFromlist(notification.id);
                      },
                      child: Icon(
                        FontAwesomeIcons.trashAlt,
                        size: 19,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                child: Text(
                  notification.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.bottomLeft,
                child: Text(
                  notification.date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: mainColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isloading = false;
  getOrders() async {
    final url =
        'https://thegradiant.com/rital_water/rital_water/api/usernotifications';
    final headers = {"Authorization": "Bearer " + token};
    print("url  :  $url");
    setState(() {
      isloading = true;
    });
    final response = await http.post(url, headers: headers);
    print("ressss : ${response.body}");
    final ordersJson = json.decode(response.body) as List<dynamic>;
    ordersJson.forEach((notif) {
      final orderData = NotificationModel(
        id: notif['id'].toString(),
        date: notif['created_at'],
        title: notif['title'],
        body: notif['body'],
      );
      notifications.add(orderData);
    });
    notifications = notifications.reversed.toList();
    setState(() {
      isloading = false;
    });
  }

  Future<void> deleteFromlist(String id) async {
    notifications = [];
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };
    setState(() {
      isloading = true;
    });
    final Uri url = Uri.parse(
        "http://thegradiant.com/rital_water/rital_water/api/deleteNotificationByUser");
    final response = await http.post(
      url,
      headers: isRegistered() ? headers : null,
      body: {'id': id},
    );
    showSnackBar("تمت الازالة من الاشعارات");
    setState(() {
      getOrders();
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
}

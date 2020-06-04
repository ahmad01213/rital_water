import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as notif;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ritakwaterapp/DataLayer/User.dart';
import 'package:ritakwaterapp/DataLayer/product.dart';
import 'package:ritakwaterapp/UI/Screens/home_screen.dart';
import 'package:ritakwaterapp/UI/Screens/main_page.dart';
import 'package:ritakwaterapp/shared_data.dart';
import 'package:device_info/device_info.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  readToken() async {
    final storage = new FlutterSecureStorage();
    token = await storage.read(key: "token");
    getProducts(token);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Image.asset(
        "assets/images/logo.png",
        width: 150,
        height: 150,
        fit: BoxFit.fill,
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    readToken();
    readFireToken();
    flutterLocalNotificationsPlugin =
        new notif.FlutterLocalNotificationsPlugin();
    var android = new notif.AndroidInitializationSettings('@drawable/logo');
    var iOS = new notif.IOSInitializationSettings();
    var initSetttings = new notif.InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings);

    _firebaseMessaging.subscribeToTopic('rital_users');
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showNotification(
            message['notification']['title'], message['notification']['body']);
      },
      onBackgroundMessage: null,
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  notif.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      notif.FlutterLocalNotificationsPlugin();
  showNotification(title, body) async {
    var android = new notif.AndroidNotificationDetails(
        '65', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: notif.Priority.High, importance: notif.Importance.High);
    var iOS = new notif.IOSNotificationDetails();
    var platform = new notif.NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, title, body, platform,
        payload: 'Nitish Kumar Singh is part time Youtuber');
  }

  readFireToken() async {
    firetoken = await _firebaseMessaging.getToken();
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  getToken() async {
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    var build = await deviceInfoPlugin.androidInfo;
    identifier = build.id.toString();
    print("token : $identifier");
  }

  getProducts(String token) async {
    products.clear();
    print('initial  ${products.length}');
    final url = 'http://thegradiant.com/rital_water/rital_water/api/products';
    final headers =
        isRegistered() ? {"Authorization": "Bearer " + token} : null;
    print("url  :  $url");
    final response = await http.post(url, headers: headers);
    print("ressss : ${response.body}");
    final productsJson = json.decode(response.body) as Map<String, dynamic>;
    productsJson['products'].forEach((p) {
      final product = Product(
        image: p['image'],
        name: p['name'],
        desc: p['desc'],
        price: p['price'],
        id: p['id'],
        productType: p['type'],
        createdAt: "",
        discount: p['discount'],
        isFavorite: p['isFavorite'],
        published: p['published'],
      );
      products.add(product);
    });
    productsJson['pages'].forEach((page) {
      if (page['type'].toString().trim() == "about") {
        aboutUs = page['text'];
      } else if (page['type'].toString().trim() == "points_per_rial") {
        pointsPerRial = int.parse(page['text']);
        print("perRial: $pointsPerRial ");
      }
    });
    productsJson['slider'].forEach((slider) {
      sliders.add(slider['image'].toString());
    });
    if (isRegistered()) {
      try {
        user = User(
            name: productsJson['user_details']['name'],
            phone: productsJson['user_details']['phone']);
      } catch (e) {
//        removeToken(context);
      }
    }

    print('last  ${products.length}');
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(builder: (context) => new MainScreen()),
    );
  }

  removeToken(context) async {
    final storage = new FlutterSecureStorage();
    await storage.delete(
      key: 'token',
    );
    setState(() {
      token = null;
    });
  }
}

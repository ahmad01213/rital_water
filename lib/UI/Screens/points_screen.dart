import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../shared_data.dart';
import 'package:http/http.dart' as http;

class PointsScreen extends StatefulWidget {
  @override
  _PointsScreenState createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          'نقاطي',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isRegistered()
          ? isloading
              ? Center(
                  child: Container(
                    child: SpinKitPulse(
                        duration: Duration(milliseconds: 1000),
                        color: mainColor,
                        size: 70
//                    lineWidth: 2,
                        ),
                    width: 100,
                    height: 100,
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  margin: EdgeInsets.all(10),
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                        side: new BorderSide(color: mainColor, width: 0.5),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    child: Center(
                      child: Wrap(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'رصيدك من النقاط',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                '$points نقطة',
                                style: TextStyle(
                                    color: mainColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Divider(
                                height: 1,
                                endIndent: 10,
                                indent: 10,
                                thickness: 1,
                                color: mainColor,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                margin: EdgeInsets.all(20),
                                child: Text(
                                  'علي كل طلب تحصل علي 10 نفاط تضاف الي رصيدك',
                                  style: TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(20),
                                child: Text(
                                  'علي كل 100 نقطة سوف تحصل علي 10 ريال من ريتال',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
          : Center(
              child: Text(
                'الرجاء تسجيل الدخول',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    getPoints();
  }

  bool isloading = false;
  String points;

  getPoints() async {
    final url =
        'https://thegradiant.com/rital_water/rital_water/api/getuserpoints';
    final headers = {"Authorization": "Bearer " + token};
    print("url  :  $url");
    setState(() {
      isloading = true;
    });
    final response = await http.post(url, headers: headers);
    print("ressss : ${response.body}");
    final jsons = json.decode(response.body) as Map<String, dynamic>;
    setState(() {
      isloading = false;
      points = jsons['points'];
    });
  }
}

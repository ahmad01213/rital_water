import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ritakwaterapp/DataLayer/Cart.dart';
import 'package:ritakwaterapp/DataLayer/product.dart';
import 'package:ritakwaterapp/helpers/DBHelper.dart';
import '../../shared_data.dart';
import 'package:http/http.dart' as http;

enum SingingCharacter { lafayette, jefferson }

class ConfiremOrderScreen extends StatefulWidget {
  bool isCash = true;
  var carts;
  String totalCost;
  String selectedLate = locationData.latitude.toString();
  String selectedLng = locationData.longitude.toString();

  ConfiremOrderScreen({this.carts, this.totalCost});
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(locationData.latitude, locationData.longitude),
    zoom: 19.151926040649414,
  );
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(locationData.latitude, locationData.longitude),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  @override
  _ConfiremOrderScreenState createState() => _ConfiremOrderScreenState();
}

class _ConfiremOrderScreenState extends State<ConfiremOrderScreen> {
  LatLng cameraLocation;
  bool isFullScreen = false;
  Completer<GoogleMapController> _controller = Completer();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          'تأكيد الطلب',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 17, color: textColor),
        ),
        centerTitle: true,
        backgroundColor: mainColor,
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: isFullScreen ? MediaQuery.of(context).size.height : 200,
            right: 0,
            bottom: 0,
            child: Container(
              margin: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    _buildNameField(),
                    _buildPhonField(),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 30, 10),
                      alignment: Alignment.topRight,
                      child: Text(
                        'طريقة الدفع',
                        style: TextStyle(
                            color: mainColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    buildListItem('الدفع كاش ( عند الاستلام )',
                        isCash ? Icons.check_circle : Icons.blur_circular, 0),
                    buildListItem('التحويل البنكي',
                        isCard ? Icons.check_circle : Icons.blur_circular, 1),
                    points != null &&
                            double.parse(points) >
                                double.parse(widget.totalCost) * pointsPerRial
                        ? buildListItem(
                            'استبدل نقاطي ( لديك $points انقطة)',
                            isPoints ? Icons.check_circle : Icons.blur_circular,
                            2)
                        : Container(),
                    _buildSubmitButton(context),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
          //google map
          Positioned(
            child: Stack(
              children: <Widget>[
                _showGoogleMaps ? googleMap() : Container(),
                Center(
                  child: Container(
                    height: 40,
                    width: 40,
                    child: Image.asset('assets/images/pin.png'),
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 20,
                  child: Container(
                    height: 35,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: mainColor),
                    child: MaterialButton(
                      child: Text(
                        'تحديد هنا',
                        style: TextStyle(
                            color: textColor, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        widget.selectedLate =
                            cameraLocation.latitude.toString();
                        widget.selectedLng =
                            cameraLocation.longitude.toString();

                        showSnackBar('تم تحديد الموقع بنجاح');
                      },
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Color(0xFF520B0A0A),
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: _goToTheLake,
                          child: Icon(
                            Icons.my_location,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        height: 35,
                        margin: EdgeInsets.all(10),
                        width: 35,
                      ),
                      Container(
                        height: 35,
                        margin: EdgeInsets.all(10),
                        color: Color(0xFF520B0A0A),
                        width: 35,
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            setState(() {
                              isFullScreen = !isFullScreen;
                            });
                          },
                          child: Icon(
                            Icons.zoom_out_map,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            left: 0,
            top: 0,
            right: 0,
            height:
                isFullScreen ? MediaQuery.of(context).size.height - 100 : 200,
          ),
          isloading
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
              : Container(),
        ],
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(ConfiremOrderScreen._kLake));
  }

  bool _showGoogleMaps = false;

  Widget googleMap() => GoogleMap(
        onCameraMove: (pos) {
          cameraLocation = pos.target;
        },
        onCameraIdle: () {
          cameraLocation != null ? print(cameraLocation.longitude) : print("");
        },
        mapType: MapType.normal,
        initialCameraPosition: ConfiremOrderScreen._kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      );

  void showMap() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _showGoogleMaps = true;
      });
    });
  }

  final Map<String, dynamic> formData = {'user_name': null, 'phone': null};
  final _formKey = GlobalKey<FormState>();

  Widget _buildNameField() {
    return TextFormField(
      initialValue: isRegistered() ? user.name : '',
      enabled: isRegistered() ? false : true,
      decoration: InputDecoration(
          labelText: ' الاسم بالكامل', labelStyle: TextStyle(fontSize: 14)),
      validator: (String value) {
        if (value.isEmpty) {
          return 'الرجاء كتابة إسمك';
        }
      },
      onSaved: (String value) {
        formData['user_name'] = value;
      },
    );
  }

  Widget _buildSubmitButton(ctx) {
    return Container(
      width: MediaQuery.of(ctx).size.width,
      height: 50,
      margin: EdgeInsets.only(top: 50),
      child: RaisedButton(
        color: mainColor,
        onPressed: () {
          _submitForm(ctx);
        },
        child: Text(
          'اطلب الان',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
        ),
      ),
    );
  }

  Widget _buildPhonField() {
    return TextFormField(
      initialValue: isRegistered() ? user.phone : '',
      enabled: isRegistered() ? false : true,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: ' رقم الموبايل', labelStyle: TextStyle(fontSize: 14)),
      validator: (String value) {
        if (value.isEmpty) {
          return 'الرجاء كتابة رقم الموبايل';
        }
      },
      onSaved: (String value) {
        formData['phone'] = value;
      },
    );
  }

  void _submitForm(ctx) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save(); //onSaved is called!
      confirmOrder(formData, ctx);
    }
  }

  bool isloading = false;
  Future<void> confirmOrder(Map<String, dynamic> params, context) async {
//    params['products'] = params['name'];
    print(user.phone);
    print("json : ${widget.carts}");
    params['name'] = user.name;
    params['phone'] = user.phone;
    params['payment_type'] = selectedPayment;
    params['products'] = "${widget.carts.toString()}";
    params['lat'] = widget.selectedLate;
    params['lng'] = widget.selectedLng;
    params['total_cost'] = widget.totalCost;
    params['accepted'] = "0";
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };
    setState(() {
      isloading = true;
    });
    final Uri url = Uri.parse(
        "http://thegradiant.com/rital_water/rital_water/api/useraddorder");
    final response = await http.post(
      url,
      headers: isRegistered() ? headers : null,
      body: params,
    );
    print("response  :  ${response.statusCode}");
    setState(() {
      isloading = false;
    });
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              "شكرا لك تم استلام طلبك بنجاح سيقوم مندوبتا بتوصيل طلبك في اسرع وقت ممكن",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            content: Text(""),
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
                  Navigator.pop(context, 'yes');
                },
              ),
            ],
          );
        });
    DBHelper.clearCart();
  }

  @override
  void initState() {
    showMap();
    getPoints();
  }

  String selectedPayment = 'كاش';
  Widget buildListItem(title, IconData icon, index) {
    return InkWell(
      onTap: () {
        setState(() {
          resetPayment();
          if (index == 0) {
            isCash = true;
            selectedPayment = 'كاش';
          } else if (index == 1) {
            isCard = true;
            selectedPayment = 'التحويل البنكي';
          }
          if (index == 2) {
            isPoints = true;
            selectedPayment = 'نقاط';
          }
        });
      },
      child: Container(
          height: 60,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: 250,
                alignment: Alignment.topRight,
                margin: EdgeInsets.fromLTRB(20, 15, 20, 10),
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Icon(
                icon,
                color: mainColor,
                size: 25,
              ),
            ],
          )),
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

  bool isCash = true;
  bool isCard = false;
  bool isPoints = false;
  resetPayment() {
    isCash = false;
    isCard = false;
    isPoints = false;
  }

  String points;
  getPoints() async {
    final url =
        'https://thegradiant.com/rital_water/rital_water/api/getuserpoints';
    final headers = {"Authorization": "Bearer " + token};
    print("url  :  $url");
    final response = await http.post(url, headers: headers);
    print("ressss : ${response.body}");
    final jsons = json.decode(response.body) as Map<String, dynamic>;
    setState(() {
      points = jsons['points'];
    });
  }
}

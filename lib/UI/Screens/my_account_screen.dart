import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:ritakwaterapp/DataLayer/User.dart';

import '../../shared_data.dart';

class MyAccountScreen extends StatefulWidget {
  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 10,
        title: Text(
          "حسابي",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(30),
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              Container(
                height: 135,
                width: 117,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.fill,
                ),
              ),
              _buildForm(context),
              SizedBox(
                height: 20,
              ),
              isRegistered() ? Container() : buildSocondButton(context)
            ],
          ),
        ),
      ),
    );
  }

  bool isRegister = false;
  Widget _buildForm(context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: isRegister ? 20 : 1,
            ),
            isRegister || isRegistered() ? _buildNameField() : Container(),
            SizedBox(
              height: 20,
            ),
            _buildPhonField(),
            SizedBox(
              height: 20,
            ),
            isRegistered() ? Container() : _buildPasswordField(),
            SizedBox(
              height: 20,
            ),
            isloading
                ? SpinKitPulse(
                    duration: Duration(milliseconds: 1000),
                    color: mainColor,
                    size: 50
//                    lineWidth: 2,
                    )
                : _buildSubmitButton(context),
          ],
        ));
  }

  Widget _buildNameField() {
    return TextFormField(
      initialValue: isRegistered() ? user.name : "",
      decoration: InputDecoration(labelText: ' الاسم بالكامل'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'الرجاء كتابة إسمك';
        }
      },
      onSaved: (String value) {
        formData['name'] = value;
      },
      enabled: isRegistered() ? false : true,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'كلمة السر',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'الرجاء كتابة كلمة السر';
        }
      },
      onSaved: (String value) {
        formData['password'] = value;
      },
    );
  }

  Widget _buildPhonField() {
    return TextFormField(
      initialValue: isRegistered() ? user.phone : "",
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: ' رقم الموبايل'),
      validator: validateMobile,
      onSaved: (String value) {
        formData['phone'] = value;
      },
      enabled: isRegistered() ? false : true,
    );
  }

  Widget _buildSubmitButton(context) {
    return isRegistered()
        ? Container()
        : Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: RaisedButton(
              color: mainColor,
              onPressed: () {
                _submitForm();
              },
              child: Text(
                isRegister ? 'تسجيل' : "دخول",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
            ),
          );
  }

  loginRegister(Map<String, dynamic> params) async {
    params['device_token'] = firetoken;
    setState(() {
      isloading = true;
    });
    print(params);
    String endpoint = isRegister ? "register" : "login";
    isRegister ? print("") : params.remove("name");
    try {
      final Uri url = Uri.parse(
          "http://thegradiant.com/rital_water/rital_water/api/$endpoint");
      final response = await http.post(
        url,
        body: params,
      );
      print("response : ${response.body}");
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      token = jsonData['success']['token'];
      print("tokens  :  ${jsonData['success']['token']}");
      final storage = new FlutterSecureStorage();
      await storage.write(key: 'token', value: token);
      user = User(
          name: jsonData['success']['name'],
          phone: jsonData['success']['phone']);
      alert("شكرا لك تم تسجيل الدخول بنجاح");
      setState(() {
        isloading = false;
      });
    } catch (error) {
      isRegister
          ? alert("رقم الهاتف الذي أدخلته مسجل من قبل")
          : alert(
              "رقم الهاتف او كلمة السر غير صحيحة , الرجاء التأكد والمحاولة مجددا");

      setState(() {
        isloading = false;
      });
    }
  }

  String validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'الرجاء كتابة رقم الموبايل';
    } else if (!regExp.hasMatch(value)) {
      return 'رقم الهاتف يجب ان يبدأ ب 05 ويتكون من 10 أرقام';
    }
    return null;
  }

  alert(message) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              message,
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
                },
              ),
            ],
          );
        });
  }

  buildSocondButton(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      child: RaisedButton(
        onPressed: () {
          setState(() {
            isRegister = !isRegister;
          });
        },
        child: Text(
          isRegister ? 'لدي حساب' : 'إنشاء حساب جديد',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save(); //onSaved is called!
      loginRegister(formData);
    }
  }
}

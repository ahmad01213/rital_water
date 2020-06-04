import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import '../../shared_data.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  bool isloading = false;
  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> formData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          'تواصل معنا',
          style: TextStyle(color: textColor),
        ),
        centerTitle: true,
      ),
      body: isloading
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
          : SingleChildScrollView(
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
                    _buildForm(context)
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildForm(context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            _buildNameField(),
            SizedBox(
              height: 20,
            ),
            _buildEmailField(),
            SizedBox(
              height: 20,
            ),
            _buildPhonField(),
            SizedBox(
              height: 20,
            ),
            _buildMessageField(),
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

  Widget _buildEmailField() {
    return TextFormField(
        textAlign: TextAlign.right,
        decoration: InputDecoration(
            labelText: 'البريد الإلكتروني', alignLabelWithHint: true),
        validator: (String value) {
          if (!RegExp(
                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
              .hasMatch(value)) {
            return 'البريد الإلكتروني غير صحيح';
          }
        },
        onSaved: (String value) {
          formData['email'] = value;
        });
  }

  Widget _buildMessageField() {
    return Container(
      height: 150,
      child: TextFormField(
        maxLines: 3,
        decoration: InputDecoration(labelText: 'نص الرسالة'),
        validator: (String value) {
          if (value.isEmpty) {
            return 'الرجاء كتابة نص الرسالة';
          }
        },
        onSaved: (String value) {
          formData['message'] = value;
        },
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: ' الاسم بالكامل'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'الرجاء كتابة إسمك';
        }
      },
      onSaved: (String value) {
        formData['name'] = value;
      },
    );
  }

  Widget _buildPhonField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: ' رقم الموبايل'),
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

  Widget _buildSubmitButton(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      child: RaisedButton(
        color: mainColor,
        onPressed: () {
          _submitForm();
        },
        child: Text(
          'إرسال الرسالة',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save(); //onSaved is called!
      sendMessage(formData);
    }
  }

  Future<void> sendMessage(Map<String, dynamic> params) async {
    setState(() {
      isloading = true;
    });
    print(params);
    final Uri url = Uri.parse(
        "http://thegradiant.com/rital_water/rital_water/api/contactus");
    final response = await http.post(
      url,
      body: params,
    );

    print("response : ${response.body}");
    setState(() {
      isloading = false;
    });
    showSnackBar('تم إرسال الرسالة بنجاح وسيتم التواصل معكم في أقرب وقت ممكن');
  }

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  void showSnackBar(message) {
    scaffoldKey?.currentState?.showSnackBar(SnackBar(
      duration: Duration(seconds: 4),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../shared_data.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          'عن الشركة',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Text(
            aboutUs,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  static final htmlData = ''' ''';
  Widget html = Html(
    data: htmlData,
    //Optional parameters:
    backgroundColor: Colors.white70,
    onLinkTap: (url) {
      // open url in a webview
    },

    onImageTap: (src) {
      // Display the image in large form.
    },
  );
}

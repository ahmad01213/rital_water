import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ritakwaterapp/DataLayer/product.dart';
import 'package:ritakwaterapp/UI/Screens/product_details_screen.dart';
import 'package:ritakwaterapp/UI/Widgets/product_item.dart';
import 'package:ritakwaterapp/carousel_pro/src/carousel_pro.dart';
import '../../shared_data.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  List<Product> productsList =
      products.where((product) => product.productType == "product").toList();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text(
          "الصفحة الرئيسية",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height - 120,
        child: Column(
          children: <Widget>[
            getSlider(),
            Container(
                height: MediaQuery.of(context).size.height - 340,
                child: buildSlider(context))
          ],
        ),
      ),
    );
  }

  Widget buildSlider(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: CarouselSlider(
        viewportFraction: 0.5,
        reverse: false,
        enableInfiniteScroll: false,
        autoPlay: false,
        enlargeCenterPage: true,
        aspectRatio: 0.8,
        items: productsList.map(
          (product) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(product),
                  ),
                );
              },
              child: Container(
                child: ProductItem(
                  product: product,
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  Widget getSlider() {
    return Container(
      height: 200.0,
      child: Carousel(
        boxFit: BoxFit.fill,
        dotColor: mainColor,
        dotSize: 5.5,
        dotSpacing: 16.0,
        dotBgColor: Colors.transparent,
        showIndicator: true,
        images: buildSlideImages(),
      ),
    );
  }

  List<Widget> buildSlideImages() {
    List<Widget> images = [];
    sliders.forEach((image) {
      images.add(CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.fill,
      ));
    });
    return images;
  }
}

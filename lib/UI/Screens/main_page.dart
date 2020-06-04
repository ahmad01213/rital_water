import 'package:cuberto_bottom_bar/cuberto_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ritakwaterapp/Bloc/bloc_provider.dart';
import 'package:ritakwaterapp/Bloc/tab_bar_bloc.dart';
import 'package:ritakwaterapp/UI/Screens/notifications_screen.dart';
import 'package:ritakwaterapp/UI/Screens/points_screen.dart';

import '../../shared_data.dart';
import 'about_us_screen.dart';
import 'cart_screen.dart';
import 'contact_us_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'my_account_screen.dart';
import 'my_orders_screen.dart';
import 'offers_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();

  static Widget imageToIcon(url) {
    return ImageIcon(
      AssetImage(url),
      size: 70,
      color: Colors.black54,
    );
  }
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  removeToken(context) async {
    final storage = new FlutterSecureStorage();
    await storage.delete(
      key: 'token',
    );
    alert(context);
    setState(() {
      token = null;
    });
  }

  alert(context) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              "تم تسجيل الخروج",
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

  @override
  Widget build(BuildContext context) {
    getUserLocation();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: textColor.withOpacity(1),
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Positioned(
            child: MyHomePage(title: 'Flutter Demo Home Page'),
            left: 0,
            top: 0,
            bottom: 0,
            right: 0,
          ),
          Positioned(
              right: 15,
              top: 35,
              child: Container(
                height: 30,
                width: 30,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                  child: Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              )),
          Positioned(
            left: 15,
            top: 35,
            child: Container(
              height: 35,
              width: 35,
              child: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => sidePages[4]),
                  );
                },
                child: Icon(
                  FontAwesomeIcons.solidBell,
                  size: 25,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.fromLTRB(0, 60, 0, 20),
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.cover,
                ),
                height: 180,
                width: 170,
              ),
              rowSide(1, context, titles[0]),
              rowSide(2, context, titles[1]),
              rowSide(3, context, titles[2]),
              rowSide(4, context, titles[3]),
              rowSide(5, context, titles[4]),
              isRegistered() ? rowSide(6, context, titles[5]) : Container(),
//              rowSide(6, context, titles[5]),
//                  rowSide(7, context, titles[6]),
            ],
          ),
        ),
      ), // assign key to Scaffoldq
    );
  }

  final sidePages = [
    PointsScreen(),
    OffersScreen(),
    AboutUsScreen(),
    ContactUsScreen(),
    NotificationsScreen()
  ];

  List<ImageIcon> icons = [
    MainScreen.imageToIcon(
      "assets/images/price.png",
    ),
    MainScreen.imageToIcon("assets/images/sale.png"),
    MainScreen.imageToIcon("assets/images/focus.png"),
    MainScreen.imageToIcon("assets/images/contact-us.png"),
    MainScreen.imageToIcon("assets/images/bell.png"),
    MainScreen.imageToIcon("assets/images/exit.png"),
  ];
  List<String> titles = [
    "نقاطي",
    "عروض اليوم",
    "من نحن",
    "تواصل معنا",
    "الاشعارات",
    "تسجيل الخروج",
  ];

  Widget rowSide(int index, context, String title) {
    return Builder(
      builder: (ctx) {
        return InkWell(
          onTap: () {
            Navigator.of(ctx).pop();
            if (index < 6) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => sidePages[index - 1]),
              );
            } else {
              removeToken(context);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child:
                    Container(width: 30, height: 30, child: icons[index - 1]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  titles[index - 1],
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int currentPage;
  Color currentColor = mainColor;
  Color inactiveColor = tabsColor;
  List<Tabs> tabs = new List();
  @override
  void initState() {
    super.initState();
    currentPage = 0;
    tabs.add(Tabs(
      FontAwesomeIcons.home,
      "الرئيسية",
      Colors.white,
      getGradient(mainColor),
    ));
    tabs.add(Tabs(FontAwesomeIcons.cartPlus, "السلة", Colors.white,
        getGradient(mainColor)));
    tabs.add(Tabs(
        FontAwesomeIcons.list, "طلباتي", Colors.white, getGradient(mainColor)));
    tabs.add(Tabs(
        FontAwesomeIcons.user, "حسابي", Colors.white, getGradient(mainColor)));

    tabBarController =
        new TabController(initialIndex: currentPage, length: 4, vsync: this);
  }

  List<Widget> pages = <Widget>[
    HomeScreen(),
    CartScreen(),
    MyOrdersScreen(),
    MyAccountScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TabBarView(
            controller: tabBarController,
            physics: NeverScrollableScrollPhysics(),
            children: {0, 1, 2, 3}
                .map(
                  (index) => pages[index],
                )
                .toList()),
        bottomNavigationBar: BlocProvider(
          bloc: tabBloc,
          child: StreamBuilder<int>(
              stream: tabBloc.countStream,
              builder: (context, snapshot) {
                print("ooooooops");
                if (snapshot.data != null) {
                  tabBarController.animateTo(snapshot.data);
                }

                return CubertoBottomBar(
                  inactiveIconColor: inactiveColor,
                  tabStyle: CubertoTabStyle.STYLE_FADED_BACKGROUND,
                  selectedTab:
                      snapshot.data != null ? snapshot.data : currentPage,
                  tabs: tabs
                      .map((value) => TabData(
                          iconData: value.icon,
                          title: value.title,
                          tabColor: value.color,
                          tabGradient: value.gradient))
                      .toList(),
                  onTabChangedListener: (position, title, color) {
                    tabBloc.setCount(position);
                  },
                );
              }),
        ));
  }

  @override
  void dispose() {
//    tabBarController.dispose();
    super.dispose();
  }
}

class Tabs {
  final IconData icon;
  final String title;
  final Color color;
  final Gradient gradient;
  Tabs(this.icon, this.title, this.color, this.gradient);
}

getGradient(Color color) {
  return LinearGradient(colors: [color, color], stops: [0.0, 0.7]);
}

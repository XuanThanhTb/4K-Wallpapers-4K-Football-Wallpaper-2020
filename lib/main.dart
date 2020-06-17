import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wall_demo/menu_dashboard.dart';

void main() {
  runApp(MaterialApp(
    title: 'Ocean Wallpaper HD Best',
    theme: ThemeData(
      primarySwatch: Colors.green,
    ),
    debugShowCheckedModeBanner: false,
    home: const SplashScreen(),
  ));
}

class ListImgaePageTwo {
  final int idCheckIndex;
  final String name;
  final String image;
  ListImgaePageTwo({this.name, this.image, this.idCheckIndex});
}

class SplashScreen extends StatefulWidget {
  const SplashScreen();
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 3), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => CarWallpaper()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('SplashScreen'),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/image/banner.jpg'),
        ),
      ),
      child: Text(''),
    );
  }
}

class DataImages {
  List<String> listDataImages;
  int indexImage;
  String name;
  String data;
  DataImages({this.indexImage, this.listDataImages,this.name, this.data});
}

class CarWallpaper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football Wallpaper HD Best',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: MenuDashBoardPage(),
    );
  }
}

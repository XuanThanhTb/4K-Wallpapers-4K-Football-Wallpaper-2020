import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wall_demo/baseWidget.dart';
import 'package:wall_demo/main.dart';
import 'package:wall_demo/notications.dart';
import 'package:wall_demo/serverst.dart';
import 'package:wall_demo/showDetailHome.dart';
import 'package:wall_demo/showImages.dart';

class MenuDashBoardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MenuDashBoardPageState();
  }
}

class MenuDashBoardPageState extends State<MenuDashBoardPage> {
  bool isCollpased = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  StreamSubscription _subscription;
  Stream<String> progressStrings;
  String res;
  String both = "Both Screen", system = "System";
  bool downloading = false;
  var progressString = "";

  List<DataImages> listDataHome = [];
  List<String> listDataOcean = [];
  List<String> listDataLikes = [];

  StreamController<dynamic> _streamIsCheckInternet =
      StreamController<dynamic>.broadcast();
  StreamController<dynamic> _streamIsCheckData =
      StreamController<dynamic>.broadcast();

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    nonPersonalizedAds: true,
    keywords: <String>['Game', 'Mario'],
  );

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: "ca-app-pub-2619002416725064/8507089251",
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("BannerAd $event");
        });
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: "ca-app-pub-2619002416725064/5880925919",
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("InterstitialAd $event");
        });
  }

  @override
  void initState() {
    _getDataImageHome();
    _getDataImageOcean();
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-2619002416725064~9820170928");
    _bannerAd = createBannerAd()
      ..load()
      ..show();
    super.initState();
  }

  @override
  void dispose() {
    _streamIsCheckInternet.close();
    _streamIsCheckData.close();
    _subscription.cancel();
    _bannerAd.dispose();
    _interstitialAd.dispose();
    super.dispose();
  }

  _getDataImageOcean() {
    _streamIsCheckData.add(false);
    ApiListData().getListDataOcean().then((result) {
      if (result.data.listItem != null) {
        _streamIsCheckInternet.add(true);
        _streamIsCheckData.add(true);
        setState(() {
          listDataOcean =
              result.data.listItem.map((item) => item.image).toList();
        });
      } else {
        _streamIsCheckInternet.add(false);
        _streamIsCheckData.add(false);
      }
    }).catchError((onError) {
      _streamIsCheckData.add(false);
      _streamIsCheckInternet.add(false);
      print(onError);
    });
  }

  _getDataImageHome() {
    _streamIsCheckData.add(false);
    ApiListData().getListDataHome().then((result) {
      if (result.data.listItem != null) {
        _streamIsCheckInternet.add(true);
        _streamIsCheckData.add(true);
        setState(() {
          listDataHome = result.data.listItem.map((item) {
            return DataImages(
                name: item.name ?? '',
                data: item.image ?? '',
                indexImage: item.id ?? 0);
          }).toList();
        });
      } else {
        _streamIsCheckInternet.add(false);
        _streamIsCheckData.add(false);
      }
    }).catchError((onError) {
      _streamIsCheckData.add(false);
      _streamIsCheckInternet.add(false);
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    rateApp() {
      var url =
          "https://play.google.com/store/apps/details?id=hd.wallpapersfootball4k.hdwallpaper"
              .toString();
      launch(url);
    }

    shareApp() {
      Share.share(
          "https://play.google.com/store/apps/details?id=hd.wallpapersfootball4k.hdwallpaper",
          subject: 'Look what I made!');
    }

    aboutDisclaimer() {}

    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    bool _lights = false;

    Widget menu(context) {
      return Container(
        padding: const EdgeInsets.only(left: 18, top: 28),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Image.asset(
                    'lib/image/menu.jpg',
                    height: screenWidth < 400
                        ? 0.5 * screenWidth
                        : 0.4 * screenWidth,
                    width: screenWidth < 400
                        ? 0.5 * screenWidth
                        : 0.4 * screenWidth,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Text(
                  "More Options",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              menuItem(
                  textItems: "Our other apps",
                  events: rateApp,
                  itemColor: Colors.red,
                  itemIcons: Icons.card_giftcard),
              menuItem(
                  textItems: "Share is Caring",
                  events: shareApp,
                  itemColor: Colors.white,
                  itemIcons: Icons.share),
              menuItem(
                  textItems: "Rate this App",
                  events: rateApp,
                  itemColor: Colors.red,
                  itemIcons: Icons.favorite_border),
              menuItem(
                  textItems: "About | Disclaimer",
                  itemColor: Colors.white,
                  events: aboutDisclaimer,
                  itemIcons: Icons.error_outline),
              Padding(
                padding: const EdgeInsets.only(bottom: 68),
                child: Text(
                  "More Apps",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget dashboard(context) {
      return AnimatedPositioned(
        duration: duration,
        top: isCollpased ? 0 : 0.2 * screenHeight,
        bottom: isCollpased ? 0 : 0.2 * screenWidth,
        left: isCollpased ? 0 : 0.8 * screenWidth,
        right: isCollpased ? 0 : -0.4 * screenWidth,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Color(0xff4A4A58),
            appBar: AppBar(
              backgroundColor: Color(0xff4A4A58),
              leading: GestureDetector(
                onTap: () {
                  setState(() {
                    isCollpased = !isCollpased;
                  });
                },
                child: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Football Wallpaper 4K',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Notications()));
                    },
                    child: Icon(
                      Icons.notifications,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
              bottom: TabBar(tabs: [
                Tab(
                  child: Container(
                    child: Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Text(
                      'RANDOM',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ]),
            ),
            body: TabBarView(children: [
              Container(
                margin: EdgeInsets.only(left: 2, right: 2),
                child: StreamBuilder(
                  stream: _streamIsCheckInternet.stream,
                  initialData: true,
                  builder: (context, AsyncSnapshot<dynamic> snapshot) {
                    return snapshot.data
                        ? StreamBuilder(
                            stream: _streamIsCheckData.stream,
                            initialData: true,
                            builder:
                                (context, AsyncSnapshot<dynamic> snapshot) {
                              return snapshot.data
                                  ? Container(
                                      child: ListView.builder(
                                        itemCount: listDataHome.length,
                                        itemBuilder:
                                            (BuildContext contex, int index) {
                                          DataImages dataImages = DataImages(
                                              indexImage: listDataHome[index]
                                                      .indexImage ??
                                                  0,
                                              name: listDataHome[index].name ??
                                                  '');
                                          return Stack(
                                            children: <Widget>[
                                              Container(
                                                height: 300,
                                                width: 600,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return ShowDetailHome(
                                                              dataImages:
                                                                  dataImages);
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: CachedNetworkImage(
                                                    imageUrl: listDataHome[
                                                                index]
                                                            .data ??
                                                        'http://165.227.57.208/images/player/messi/20.jpeg',
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (context, url) =>
                                                            SpinKitCircle(
                                                      color: Color(0xff6d605f),
                                                      size: 50,
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 80,
                                                bottom: 80,
                                                left: 80,
                                                right: 80,
                                                child: Center(
                                                  child: Text(
                                                    listDataHome[index].name ??
                                                        '',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    )
                                  : Container(
                                      child: SpinKitCircle(
                                        color: Color(0xff6d605f),
                                        size: 50,
                                      ),
                                    );
                            },
                          )
                        : GestureDetector(
                            onTap: () {
                              _streamIsCheckInternet.add(true);
                              _getDataImageHome();
                            },
                            child: Center(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1, color: Color(0xFFfe832a)),
                                ),
                                height: 50,
                                width: 50,
                                child: Icon(Icons.replay,
                                    color: Color(0xFFfe832a)),
                              ),
                            ),
                          );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 2, right: 2),
                child: StreamBuilder(
                  stream: _streamIsCheckInternet.stream,
                  initialData: true,
                  builder: (context, AsyncSnapshot<dynamic> snapshot) {
                    return snapshot.data
                        ? StreamBuilder(
                            stream: _streamIsCheckData.stream,
                            initialData: true,
                            builder:
                                (context, AsyncSnapshot<dynamic> snapshot) {
                              return snapshot.data
                                  ? GridView.count(
                                      crossAxisCount: 3,
                                      childAspectRatio: 0.6,
                                      children: List.generate(
                                          listDataOcean.length, (index) {
                                        DataImages dataImages = DataImages(
                                            data: listDataOcean[index],
                                            indexImage: index,
                                            listDataImages: listDataOcean);
                                        return Card(
                                          clipBehavior: Clip.antiAlias,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return ShowImages(
                                                        dataImages: dataImages);
                                                  },
                                                ),
                                              ).then((result) {
                                                _getDataImageOcean();
                                              });
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl: listDataOcean[index],
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  SpinKitCircle(
                                                color: Color(0xff6d605f),
                                                size: 50,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        );
                                      }),
                                    )
                                  : Container(
                                      child: SpinKitCircle(
                                        color: Color(0xff6d605f),
                                        size: 50,
                                      ),
                                    );
                            },
                          )
                        : GestureDetector(
                            onTap: () {
                              _streamIsCheckInternet.add(true);
                              _getDataImageOcean();
                            },
                            child: Center(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1, color: Color(0xFFfe832a)),
                                ),
                                height: 50,
                                width: 50,
                                child: Icon(Icons.replay,
                                    color: Color(0xFFfe832a)),
                              ),
                            ),
                          );
                  },
                ),
              ),
            ]),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xff4A4A58),
      body: Stack(
        children: <Widget>[
          menu(context),
          dashboard(context),
          // _showDialogRate(),
        ],
      ),
    );
  }
}

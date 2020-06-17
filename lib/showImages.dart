import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:share/share.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wall_demo/main.dart';
import 'package:wallpaper/wallpaper.dart';

const String testDevice = 'FB91C22A544E6EBA7764AB4193D768D9';

class ShowImages extends StatefulWidget {
  final DataImages dataImages;
  ShowImages({this.dataImages});
  @override
  State<StatefulWidget> createState() {
    return ShowImagesState(this.dataImages);
  }
}

class ShowImagesState extends State<ShowImages> with TickerProviderStateMixin {
  final DataImages dataImages;
  ShowImagesState(this.dataImages);
  PageController _pageController = PageController();
  double currentPage = 0;
  Stream<String> progressStrings;
  String res;
  String both = "Both Screen", system = "System";
  bool downloading = false;
  var progressString = "";
  ProgressDialog _progressDialogSetWallpaper;
  ProgressDialog _progressDialogDownloadImage;
  double percentage = 0.0;

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    nonPersonalizedAds: true,
    keywords: <String>['Game', 'Mario'],
  );

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: "ca-app-pub-2619002416725064/5777539043",
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("BannerAd $event");
        });
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: "ca-app-pub-2619002416725064/9956457204",
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("InterstitialAd $event");
        });
  }

  @override
  void initState() {
    // _showDialogRate();
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-2619002416725064~6400355575");
    _bannerAd = createBannerAd()
      ..load()
      ..show();
    currentPage = double.parse(dataImages.indexImage.toString());
    _pageController = PageController(initialPage: dataImages.indexImage);
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page;
        print(currentPage);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd.dispose();
    super.dispose();
  }

  // _showDialogRate()  {
  //   return AlertDialog(
  //     title: Text('New Task'),
  //     actions: <Widget>[
  //       FlatButton(
  //         child: Text('Cancel'),
  //         onPressed: () {
  //           Navigator.of(context).pop();
  //         },
  //       ),
  //       FlatButton(
  //         child: Text('Add'),
  //         onPressed: () {},
  //       ),
  //     ],
  //   );
  // }

  _dowloadImage(ProgressDialog _progressDialogDownloadImage) async {
    _progressDialogDownloadImage.style(
        message: 'Downloading file...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    createInterstitialAd()
      ..load()
      ..show();

    _progressDialogDownloadImage.show();
    Future.delayed(Duration(seconds: 2)).then(
      (onvalue) {
        _progressDialogDownloadImage.update(
          progress: 0.0,
          message: "Download image...",
          maxProgress: 100.0,
          progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
        );
      },
    );
    Future.delayed(Duration(seconds: 10)).then((onValue) {
      print("PR status  ${_progressDialogDownloadImage.isShowing()}");
      if (_progressDialogDownloadImage.isShowing())
        _progressDialogDownloadImage.hide().then((isHidden) {
          print(isHidden);
        });
      print("PR status  ${_progressDialogDownloadImage.isShowing()}");
    });
    var response =
        await http.get(dataImages.listDataImages[currentPage.toInt()]);
    var filePath =
        await ImagePickerSaver.saveFile(fileData: response.bodyBytes);
    print("SHOW:" + filePath);
  }

  _onOpenUrl() {
    var url =
        "https://play.google.com/store/apps/details?id=hd.wallpapersfootball4k.hdwallpaper"
            .toString();
    launch(url);
  }

  _onBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    _progressDialogDownloadImage =
        ProgressDialog(context, type: ProgressDialogType.Normal);
    _progressDialogSetWallpaper =
        ProgressDialog(context, type: ProgressDialogType.Normal);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        child: Stack(
          children: <Widget>[
            Container(
              child: SwipeDetector(
                onSwipeRight: () {},
                child: PageView.builder(
                  itemCount: dataImages.listDataImages.length,
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int itemIndex) {
                    return Container(
                      child: CachedNetworkImage(
                        imageUrl: dataImages.listDataImages[itemIndex],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Center(
                            child: SpinKitCircle(
                              color: Color(0xff6d605f),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 80.0,
              child: new AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: _onBack,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.share,
                      ),
                      onPressed: () {
                        //link app.
                        Share.share(
                            "https://play.google.com/store/apps/details?id=hd.wallpapersfootball4k.hdwallpaper",
                            subject: 'Look what I made!');
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 94.0,
              left: 40,
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: new Border.all(
                    color: Color(0xffa7a5a5),
                    width: 4,
                  ),
                ),
                child: FloatingActionButton(
                  heroTag: "wallpaper",
                  backgroundColor: Colors.transparent,
                  onPressed: () {
                    _progressDialogSetWallpaper.show();
                    Future.delayed(Duration(seconds: 2)).then(
                      (onvalue) {
                        _progressDialogSetWallpaper.update(
                          progress: 0.0,
                          message: "Setting as wallpaper",
                          maxProgress: 100.0,
                          progressTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w400),
                          messageTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 19.0,
                              fontWeight: FontWeight.w600),
                        );
                      },
                    );
                    Future.delayed(Duration(seconds: 10)).then((onValue) {
                      print(
                          "PR status  ${_progressDialogSetWallpaper.isShowing()}");
                      if (_progressDialogSetWallpaper.isShowing())
                        _progressDialogSetWallpaper.hide().then((isHidden) {
                          print(isHidden);
                        });
                      print(
                          "PR status  ${_progressDialogSetWallpaper.isShowing()}");
                    });

                    progressStrings = Wallpaper.ImageDownloadProgress(
                        dataImages.listDataImages[currentPage.toInt()]);
                    progressStrings.listen((data) {
                      setState(() {
                        res = data;
                        downloading = true;
                      });
                      print("DataReceived: " + data);
                    }, onDone: () async {
                      both = await Wallpaper.bothScreen();
                      setState(() {
                        downloading = false;
                        both = both;
                      });
                      print("Task Done");
                    }, onError: (error) {
                      setState(() {
                        downloading = false;
                      });
                      print("Some Error");
                    });
                    setState(() {
                      downloading = true;
                    });
                    createInterstitialAd()
                      ..load()
                      ..show();
                  },
                  child: Icon(
                    Icons.wallpaper,
                    size: 30,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 114.0,
              right: 90,
              left: 90,
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: new Border.all(
                    color: Color(0xffa7a5a5),
                    width: 4,
                  ),
                ),
                child: FloatingActionButton(
                  heroTag: "save",
                  backgroundColor: Colors.transparent,
                  onPressed: () {
                    _dowloadImage(_progressDialogDownloadImage);
                  },
                  child: Icon(
                    Icons.arrow_downward,
                    size: 30,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 94.0,
              right: 40,
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: new Border.all(
                    color: Color(0xffa7a5a5),
                    width: 4,
                  ),
                ),
                child: FloatingActionButton(
                  heroTag: "reat",
                  backgroundColor: Colors.transparent,
                  onPressed: _onOpenUrl,
                  child: Icon(
                    Icons.star,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

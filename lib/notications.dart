import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wall_demo/serverst.dart';

class Notications extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoticationsState();
  }
}

class NoticationsState extends State<Notications> {
  List<DataBanner> listBanner = [];
  List<String> listUrlApp = [
    "https://play.google.com/store/apps/details?id=hd.background.blackwallpaper",
    "https://play.google.com/store/apps/details?id=hd.background.carwallpapers",
  ];
  @override
  void initState() {
    _getDataDataBanner();
    super.initState();
  }

  _getDataDataBanner() {
    // _streamIsCheckData.add(false);
    ApiListData().getListDataBannerApp().then((result) {
      if (result.data.listItem != null) {
        // _streamIsCheckInternet.add(true);
        // _streamIsCheckData.add(true);
        setState(() {
          listBanner = result.data.listItem.map((item) {
            return DataBanner(
                name: item.name,
                image: item.image,
                status: item.status,
                dayup: item.dayup);
          }).toList();
        });
      } else {
        // _streamIsCheckInternet.add(false);
        // _streamIsCheckData.add(false);
      }
    }).catchError((onError) {
      // _streamIsCheckData.add(false);
      // _streamIsCheckInternet.add(false);
      print(onError);
    });
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff4A4A58),
        appBar: AppBar(
          backgroundColor: Color(0xff4A4A58),
          title: Center(
              child: Text(
            'Notifications',
            style: TextStyle(color: Colors.white),
          )),
        ),
        body: Container(
          child: ListView.builder(
            itemCount: listBanner.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      launch(listUrlApp[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            leading: Image.network(
                              listBanner[index].image,
                              fit: BoxFit.contain,
                            ),
                            title: Text(
                              listBanner[index].name,
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  listBanner[index].status,
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  listBanner[index].dayup,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Container(
                      height: 1.5,
                      color: Colors.white,
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class DataBanner {
  String name;
  String image;
  String status;
  String dayup;
  DataBanner({this.name, this.image, this.status, this.dayup});
}

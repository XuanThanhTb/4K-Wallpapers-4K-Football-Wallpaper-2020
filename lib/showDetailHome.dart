import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wall_demo/main.dart';
import 'package:wall_demo/serverst.dart';
import 'package:wall_demo/showImages.dart';

class ShowDetailHome extends StatefulWidget {
  final DataImages dataImages;
  ShowDetailHome({this.dataImages});
  @override
  State<StatefulWidget> createState() {
    return ShowDetailHomeState(this.dataImages);
  }
}

class ShowDetailHomeState extends State<ShowDetailHome> {
  DataImages dataImages;
  ShowDetailHomeState(this.dataImages);
  List<String> listDataDetailHome = [];
  StreamController<dynamic> _streamIsCheckInternet =
      StreamController<dynamic>.broadcast();
  StreamController<dynamic> _streamIsCheckData =
      StreamController<dynamic>.broadcast();

  @override
  void initState() {
    _getDataImageDetail();
    super.initState();
  }

  _getDataImageDetail() {
    _streamIsCheckData.add(false);
    ApiListData()
        .getListDataDetails(id: dataImages.indexImage.toInt() ?? 0)
        .then((result) {
      if (result.data.listItem != null) {
        _streamIsCheckInternet.add(true);
        _streamIsCheckData.add(true);
        setState(() {
          listDataDetailHome =
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Color(0xff4A4A58),
        appBar: AppBar(
          backgroundColor: Color(0xff4A4A58),
          title: Text(dataImages.name),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 2, right: 2),
          child: StreamBuilder(
            stream: _streamIsCheckInternet.stream,
            initialData: true,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              return snapshot.data
                  ? StreamBuilder(
                      stream: _streamIsCheckData.stream,
                      initialData: true,
                      builder: (context, AsyncSnapshot<dynamic> snapshot) {
                        return snapshot.data
                            ? GridView.count(
                                crossAxisCount: 3,
                                childAspectRatio: 0.6,
                                children: List.generate(
                                    listDataDetailHome.length, (index) {
                                  DataImages dataImages = DataImages(
                                      data: listDataDetailHome[index],
                                      indexImage: index,
                                      listDataImages: listDataDetailHome);
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
                                          _getDataImageDetail();
                                        });
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: listDataDetailHome[index],
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            SpinKitCircle(
                                          color: Color(0xff6d605f),
                                          size: 50,
                                        ),
                                        errorWidget: (context, url, error) =>
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
                        _getDataImageDetail();
                      },
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border:
                                Border.all(width: 1, color: Color(0xFFfe832a)),
                          ),
                          height: 50,
                          width: 50,
                          child: Icon(Icons.replay, color: Color(0xFFfe832a)),
                        ),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}

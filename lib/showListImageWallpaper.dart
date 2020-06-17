// import 'dart:async';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:wall_demo/main.dart';
// import 'package:wall_demo/serverst.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:wall_demo/showImages.dart';

// class ShowListImageWallpaper extends StatefulWidget {
//   final ListImgaePageTwo listImgaePageTwo;
//   ShowListImageWallpaper({this.listImgaePageTwo});

//   @override
//   State<StatefulWidget> createState() {
//     return ShowListImageWallpaperState(this.listImgaePageTwo);
//   }
// }

// class ShowListImageWallpaperState extends State<ShowListImageWallpaper> {
//   final ListImgaePageTwo listImgaePageTwo;
//   ShowListImageWallpaperState(this.listImgaePageTwo);
//   StreamController<dynamic> _streamIsCheckInternet =
//       StreamController<dynamic>.broadcast();
//   StreamController<dynamic> _streamIsCheckData =
//       StreamController<dynamic>.broadcast();

//   List<String> listDataFlower = [];
//   List<String> listDataRain = [];
//   List<String> listDataRandom = [];

//   _onBack() {
//     Navigator.pop(context);
//   }

//   @override
//   void initState() {
//     _getDetailData();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _streamIsCheckInternet.close();
//     _streamIsCheckData.close();
//     super.dispose();
//   }

//   _getDetailData() {
//     if (listImgaePageTwo.idCheckIndex != 1 &&
//         listImgaePageTwo.idCheckIndex != 2 &&
//         listImgaePageTwo.idCheckIndex != 3) return;
//     if (listImgaePageTwo.idCheckIndex == 1) {
//       _getDataImageFlower();
//     } else if (listImgaePageTwo.idCheckIndex == 2) {
//       _getDataImageRain();
//     } else {
//       _getDataImageRandom();
//     }
//   }

//   _getDataImageFlower() {
//     _streamIsCheckData.add(false);
//     ApiListData().getListDataFlower().then((result) {
//       if (result.data.listItem != null) {
//         _streamIsCheckInternet.add(true);
//         _streamIsCheckData.add(true);
//         setState(() {
//           listDataFlower =
//               result.data.listItem.map((item) => item.image).toList();
//         });
//       } else {
//         _streamIsCheckInternet.add(false);
//         _streamIsCheckData.add(false);
//       }
//     }).catchError((onError) {
//       _streamIsCheckData.add(false);
//       _streamIsCheckInternet.add(false);
//       print(onError);
//     });
//   }

//   _getDataImageRain() {
//     _streamIsCheckData.add(false);
//     ApiListData().getListDataRain().then((result) {
//       if (result.data.listItem != null) {
//         _streamIsCheckInternet.add(true);
//         _streamIsCheckData.add(true);
//         setState(() {
//           listDataRain =
//               result.data.listItem.map((item) => item.image).toList();
//         });
//       } else {
//         _streamIsCheckInternet.add(false);
//         _streamIsCheckData.add(false);
//       }
//     }).catchError((onError) {
//       _streamIsCheckData.add(false);
//       _streamIsCheckInternet.add(false);
//       print(onError);
//     });
//   }

//   _getDataImageRandom() {
//     _streamIsCheckData.add(false);
//     ApiListData().getListDataRandom().then((result) {
//       if (result.data.listItem != null) {
//         _streamIsCheckInternet.add(true);
//         _streamIsCheckData.add(true);
//         setState(() {
//           listDataRandom =
//               result.data.listItem.map((item) => item.image).toList();
//         });
//       } else {
//         _streamIsCheckInternet.add(false);
//         _streamIsCheckData.add(false);
//       }
//     }).catchError((onError) {
//       _streamIsCheckData.add(false);
//       _streamIsCheckInternet.add(false);
//       print(onError);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       top: false,
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: _onBack,
//           ),
//           backgroundColor: Colors.black,
//           title: Text(listImgaePageTwo.name),
//         ),
//         body: Container(
//           margin: EdgeInsets.only(left: 2, right: 2),
//           child: StreamBuilder(
//             stream: _streamIsCheckInternet.stream,
//             initialData: true,
//             builder: (context, AsyncSnapshot<dynamic> snapshot) {
//               return snapshot.data
//                   ? StreamBuilder(
//                       stream: _streamIsCheckData.stream,
//                       initialData: true,
//                       builder: (context, AsyncSnapshot<dynamic> snapshot) {
//                         return snapshot.data
//                             ? GridView.count(
//                                 crossAxisCount: 3,
//                                 childAspectRatio: 0.7,
//                                 children: List.generate(
//                                     listImgaePageTwo.idCheckIndex == 1
//                                         ? listDataFlower.length
//                                         : listImgaePageTwo.idCheckIndex == 2
//                                             ? listDataRain.length
//                                             : listDataRandom.length, (index) {
//                                   DataImages dataImages = DataImages(
//                                       data: listImgaePageTwo.idCheckIndex == 1
//                                           ? listDataFlower[index]
//                                           : listImgaePageTwo.idCheckIndex == 2
//                                               ? listDataRain[index]
//                                               : listDataRandom[index],
//                                       indexImage: index,
//                                       listDataImages:
//                                           listImgaePageTwo.idCheckIndex == 1
//                                               ? listDataFlower
//                                               : listImgaePageTwo.idCheckIndex ==
//                                                       2
//                                                   ? listDataRain
//                                                   : listDataRandom);
//                                   return Card(
//                                     clipBehavior: Clip.antiAlias,
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) {
//                                               return ShowImages(
//                                                   dataImages: dataImages);
//                                             },
//                                           ),
//                                         );
//                                       },
//                                       child: CachedNetworkImage(
//                                         imageUrl: listImgaePageTwo
//                                                     .idCheckIndex ==
//                                                 1
//                                             ? listDataFlower[index]
//                                             : listImgaePageTwo.idCheckIndex == 2
//                                                 ? listDataRain[index]
//                                                 : listDataRandom[index],
//                                         fit: BoxFit.cover,
//                                         placeholder: (context, url) =>
//                                             SpinKitCircle(
//                                           color: Color(0xff6d605f),
//                                           size: 50,
//                                         ),
//                                         errorWidget: (context, url, error) =>
//                                             Icon(Icons.error),
//                                       ),
//                                     ),
//                                   );
//                                 }),
//                               )
//                             : Container(
//                                 child: SpinKitCircle(
//                                   color: Color(0xff6d605f),
//                                   size: 50,
//                                 ),
//                               );
//                       },
//                     )
//                   : GestureDetector(
//                       onTap: () {
//                         _streamIsCheckInternet.add(true);
//                         _getDetailData();
//                       },
//                       child: Center(
//                         child: Container(
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                             border:
//                                 Border.all(width: 1, color: Color(0xFFfe832a)),
//                           ),
//                           height: 50,
//                           width: 50,
//                           child: Icon(Icons.replay, color: Color(0xFFfe832a)),
//                         ),
//                       ),
//                     );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:sunny/core/config/color/colorConfig.dart';
// import 'package:sunny/core/service/weather_service.dart';
// import 'package:sunny/feature/detailNews/view/detail_news_view.dart';
// import 'package:webfeed/domain/rss_feed.dart';

// class ListNewsView extends StatefulWidget {
//   const ListNewsView({Key key}) : super(key: key);

//   @override
//   _ListNewsViewState createState() => _ListNewsViewState();
// }

// class _ListNewsViewState extends State<ListNewsView> {

//   HomeService homeService = HomeService();

//   void gotoDetailNews(String url) {

//     Future.delayed(Duration(milliseconds: 500)).then((value) {

//       Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => DetailNewsView(url: url)));

//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: ColorConfig.darkBackgroundColor,
//         title: Text("Berita Cuaca",style: TextStyle(
//           fontSize: 18,
//           color: ColorConfig.textLabelDark,
//           fontWeight: FontWeight.bold,
//           fontFamily: 'NunitoBold',
//         )
//         ),
//       ),
//       backgroundColor: ColorConfig.darkBackgroundColor,
//       body: Container(
//         child: StreamBuilder(
//           stream: homeService.getNewsFromRss().asStream(),
//           builder: (contex, AsyncSnapshot<RssFeed> snapshot) {
//             if(snapshot.hasData) {

//               var itemsList = snapshot.data.items.where((i) => i.description.toLowerCase().contains("cuaca")).toList();

//               return RefreshIndicator(
//                 color: ColorConfig.mainColor,
//                 onRefresh: () {
//                   return Future.delayed(Duration(milliseconds: 500), () {
//                     homeService.getNewsFromRss();
//                   });
//                 },
//                 child: ListView.builder(
//                         itemCount: itemsList.length,
//                         itemBuilder: (ctx, idx) {

//                           var items = itemsList[idx];
//                           var dateFormat = new DateFormat('EEEE, dd MMMM yyyy', "id_ID");
//                           var fixedDate = dateFormat.format(items.pubDate);

//                           return Container(
//                             margin: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
//                             child: Material(
//                               color: Colors.transparent,
//                               child: InkWell(
//                                 highlightColor: ColorConfig.mainColor.withOpacity(.2),
//                                 splashColor: ColorConfig.mainColor.withOpacity(.2),
//                                 onTap: () => {this.gotoDetailNews(items.link)},
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     ClipRRect(
//                                       child: Image(
//                                         width: 100,
//                                         image: NetworkImage(items.enclosure.url),
//                                         fit: BoxFit.fill,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     Expanded(
//                                       child: Container(
//                                         padding: EdgeInsets.only(left: 8, right: 8),
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: [
//                                             Text(items.title, style: TextStyle(
//                                                 fontSize: 12,
//                                                 color: ColorConfig.textColorLight,
//                                                 fontFamily: 'NunitoBold'
//                                             ),
//                                               maxLines: 2,
//                                             ),
//                                             Padding(
//                                               child: Text(fixedDate, style: TextStyle(
//                                                   fontSize: 11,
//                                                   color: ColorConfig.textLabelDark,
//                                                   fontFamily: 'NunitoRegular'
//                                               ),
//                                                 maxLines: 1,
//                                               ),
//                                               padding: EdgeInsets.only(top: 8),
//                                             ),
//                                           ],
//                                         ),
//                                       ),

//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                 ),
//               );
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Text(snapshot.error.toString(), style: TextStyle(
//                     color: Colors.white
//                 )),
//               );
//             }

//             return Container();
//           },
//         ),
//       ),
//     );
//   }
// }

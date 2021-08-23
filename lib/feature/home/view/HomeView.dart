import 'dart:ffi';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sunny/core/config/color/colorConfig.dart';
import 'package:sunny/core/config/helper/conditionHelper.dart';
import 'package:sunny/core/config/helper/convertHelper.dart';
import 'package:sunny/core/config/notification/notificationManager.dart';
import 'package:sunny/core/model/weatherForecastModel.dart';
import 'package:sunny/core/service/weatherService.dart';
import 'package:sunny/feature/detailForecast/view/detailForecastHourly.dart';
import 'package:sunny/feature/detailNews/view/detailNewsView.dart';
import 'package:sunny/feature/listNews/view/listNewsView.dart';
import 'package:sunny/feature/mainTabbar/mainTabbar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:webfeed/domain/rss_feed.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeService homeService = HomeService();

  WeatherForecastModel weatherForecastModel = WeatherForecastModel();
  NotificationManager notificationManager = NotificationManager();
  bool isLoading = true;

  var address = "Mendapatkan Lokasimu";
  var isForecast = true;

  void gotoDetail(Hourly weatherHourly) {
    print("detail view");

    /// pong ini biar inkwell nya ga terlalu cepet , jadi animasi ke teken dulu ,
    /// baru eksekusi pindah halaman
    Future.delayed(Duration(milliseconds: 500)).then((value) {

      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          DetailForecastHourly(
            weatherHourly: weatherHourly,
            address: address,
          )
      )
      );
    });

  }

  void gotoDetailNews(String url) {

    Future.delayed(Duration(milliseconds: 500)).then((value) {

      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => DetailNewsView(url: url)));

    });

  }

  void gotoListNews() {

    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ListNewsView()));
  }

  void getCurrentLocation() async {
    var position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    var lastPosition = await Geolocator().getLastKnownPosition();
    print(lastPosition);

    print("$position.latitude, $position.longitude");

    if (position.latitude != null || position.longitude != null) {
      _getAddressFromLatLng(position.latitude, position.longitude);
      getForecast(position.latitude.toString(), position.longitude.toString());
    }
  }

  _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<geo.Placemark> placemarks =
          await geo.placemarkFromCoordinates(latitude, longitude);

      geo.Placemark place = placemarks[0];

      print("${place.locality}, ${place.postalCode}, ${place.country}");

      if (place.locality != "") {
        setState(() {
          address = "${place.locality}, ${place.country}";
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void getForecast(String latitude, String longitude) {
    if (weatherForecastModel == null) {
      setState(() {
        isLoading = true;
      });
    }

    homeService.getCurrentWeatherByLatLong(latitude, longitude).then((value) {

      setState(() {
        weatherForecastModel = value;
        isLoading = false;
      });

      notificationManager.showScheduleNotification(
          id: 0,
          title: "Cuaca hari ini " + ConditionHelper.getDescription(weatherForecastModel.current),
          body: "Temperatur nya " + weatherForecastModel.current.temp.toStringAsFixed(1) +
              "°C",
          hour: 10,
          imagePath: ConditionHelper.getImageNotifFromCondition(weatherForecastModel.current.weather[0].icon)["icon"],
          imageDescription: ConditionHelper.getDescription(weatherForecastModel.current)
      );

      notificationManager.showScheduleNotification(
          id: 1,
          title: "Cuaca besok " + ConditionHelper.getDescriptionDaily(weatherForecastModel.daily[1]),
      body: "Temperatur nya " + weatherForecastModel.current.temp.toStringAsFixed(1) +
      "°C",
      hour: 20,
      imagePath:  ConditionHelper.getImageNotifFromCondition(weatherForecastModel.daily[1].weather[0].icon)["icon"],
      imageDescription: ConditionHelper.getDescriptionDaily(weatherForecastModel.daily[1])
      );
    });
  }

  void getNews() {

    homeService.getNewsFromRss().then((value) {

      print(value.items[0].title);

    });
  }

  void gotoFullReport() {

    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => MainTabbar(selectedIndex: 2)));

  }

  @override
  void didChangeDependencies() {

    getCurrentLocation();

    super.didChangeDependencies();
  }

  @override
  void initState() {

    getCurrentLocation();
    getNews();

    initializeDateFormatting();

    super.initState();
  }

  Widget header() {
    var dateFormat = new DateFormat('EEEE, dd MMMM yyyy', "id_ID");

    var currentDate = dateFormat.format(DateTime.now());

    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, top: 30),
      padding: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Text(
              address,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorConfig.textLabelDark,
                fontWeight: FontWeight.bold,
                fontFamily: 'NunitoSemiBold',
                fontSize: 18,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            child: Text(
              currentDate.toString(),
              style: TextStyle(
                  color: ColorConfig.textLabelDark,
                  fontSize: 12,
                  fontFamily: 'NunitoRegular',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 8, right: 8, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 8),
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isForecast == true
                        ? ColorConfig.mainColor
                        : ColorConfig.colorWidget,
                  ),
                  child: FlatButton(
                    minWidth: 100,
                    onPressed: () {
                      setState(() {
                        isForecast = true;
                      });
                    },
                    child: Text(
                      "Cuaca",
                      style: TextStyle(
                        color: ColorConfig.textColorLight,
                        fontFamily: 'NunitoSemiBold',
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 8),
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isForecast == false
                        ? ColorConfig.mainColor
                        : ColorConfig.colorWidget,
                  ),
                  child: FlatButton(
                    minWidth: 100,
                    onPressed: () {
                      setState(() {
                        isForecast = false;
                      });
                    },
                    child: Text(
                      "Kualitas Udara",
                      style: TextStyle(
                        color: ColorConfig.textColorLight,
                        fontFamily: 'NunitoSemiBold',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget weather() {
    if (isLoading == true) {
      return Container(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(ColorConfig.mainColor),
          ),
        ),
      );
    } else {
      if (weatherForecastModel != null) {
        var temp = weatherForecastModel.current.temp;

        var wind = ConvertHelper.mToKmPerHour(weatherForecastModel.current.windSpeed);

        var humidity = weatherForecastModel.current.humidity;

        return Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 16),
                child: AvatarGlow(
                  glowColor: ColorConfig.mainColor,
                  endRadius: 140.0,
                  duration: Duration(milliseconds: 3000),
                  repeat: true,
                  showTwoGlows: true,
                  repeatPauseDuration: Duration(milliseconds: 500),
                  child: Image(
                      height: 200,
                      width: 200,
                      image: AssetImage("asset/image/thunderstorm.png")
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage("asset/image/fluenttemperature.png"),
                      height: 36,
                      width: 36,
                    ),
                    Text(
                        weatherForecastModel.current.temp.toStringAsFixed(1) +
                            "°C",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: ColorConfig.textLabelDark,
                          fontFamily: 'NunitoBold',
                        )),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                child: Text(
                    ConditionHelper.getDescription(weatherForecastModel.current),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: ColorConfig.textLabelDark,
                      fontFamily: 'NunitoSemiBold',
                    )),
              ),
              isForecast == true
                  ? Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                child: Image(
                                  image: AssetImage(ConditionHelper.getIconDaily(weatherForecastModel.daily[0])),
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 6),
                                    child: Text(ConvertHelper.milisToDay(weatherForecastModel.daily[0].dt),
                                        style: TextStyle(
                                            color: ColorConfig.textColorLight,
                                            fontSize: 12,
                                            fontFamily: 'NunitoRegular',
                                        )),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            "asset/image/fluenttemperature.png"),
                                        height: 20,
                                        width: 20,
                                      ),
                                      Text(
                                          weatherForecastModel.daily[0].temp.day
                                                  .toStringAsFixed(1) +
                                              "°C",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: ColorConfig.textColorLight,
                                            fontFamily: 'NunitoBold',
                                          )),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          Container(
                            width: 1,
                            margin: EdgeInsets.only(left: 32, right: 32),
                            height: 40,
                            color: Colors.grey,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                child: Image(
                                  image: AssetImage(ConditionHelper.getIconDaily(weatherForecastModel.daily[1])),
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 6),
                                    child: Text(ConvertHelper.milisToDay(weatherForecastModel.daily[1].dt),
                                        style: TextStyle(
                                            color: ColorConfig.textColorLight,
                                            fontSize: 12,
                                            fontFamily: 'NunitoRegular',
                                        )),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            "asset/image/fluenttemperature.png"),
                                        height: 20,
                                        width: 20,
                                      ),
                                      Text(
                                          weatherForecastModel.daily[1].temp.day
                                                  .toStringAsFixed(1) +
                                              "°C",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: ColorConfig.textColorLight,
                                            fontFamily: 'NunitoBold',
                                          )),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(left: 8, right: 8, top: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                child: Image(
                                  image:
                                      AssetImage("asset/image/windspeed.png"),
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 2),
                                    child: Text("Kecepatan Angin",
                                        style: TextStyle(
                                            color: ColorConfig.textColorLight,
                                            fontSize: 12,
                                            fontFamily: 'NunitoRegular',
                                        )),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image(
                                        image:
                                            AssetImage("asset/image/speed.png"),
                                        height: 20,
                                        width: 20,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 4),
                                        child: Text(wind + " km/j",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: ColorConfig.textColorLight,
                                              fontFamily: 'NunitoBold',
                                            )),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          Container(
                            width: 1,
                            margin: EdgeInsets.only(left: 16, right: 16),
                            height: 40,
                            color: ColorConfig.colorGrey,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                child: Image(
                                  image: AssetImage("asset/image/humidity.png"),
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 6),
                                    child: Text("Kelembapan",
                                        style: TextStyle(
                                            color: ColorConfig.textColorLight,
                                            fontSize: 12,
                                            fontFamily: 'NunitoRegular',
                                        )),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            "asset/image/waterpercent.png"),
                                        height: 20,
                                        width: 20,
                                      ),
                                      Text(humidity.toStringAsFixed(0) + " %",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: ColorConfig.textColorLight,
                                            fontFamily: 'NunitoBold',
                                          )),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    )
            ],
          ),
        );
      } else {
        return Container();
      }
    }
  }

  Widget todayContainer() {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 8, right: 16, left: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hari Ini",
                  style: TextStyle(
                      fontSize: 16,
                      color: ColorConfig.textLabelDark,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NunitoBold',
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'NunitoBold',),
                  ),
                  onPressed: () {
                    this.gotoFullReport();
                  },
                  child: Text('Lihat Laporan',
                      style: TextStyle(
                          color: ColorConfig.mainColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NunitoBold',
                      )),
                ),
              ],
            ),
          ),
          weatherForecastModel.hourly != null
              ? Container(
                  height: 130,
                  margin: EdgeInsets.only(top: 4, bottom: 8, left: 8, right: 8),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(left: 4, right: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorConfig.colorWidget),
                          width: 90,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              highlightColor: ColorConfig.mainColor.withOpacity(.2),
                              splashColor: ColorConfig.mainColor.withOpacity(.2),
                              onTap: () => {this.gotoDetail(weatherForecastModel.hourly[index])},
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 8, right: 8,bottom: 4),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 8),
                                      height: 53,
                                      width: 53,
                                      child: Image(
                                        image: AssetImage(ConditionHelper.getIconHourly(weatherForecastModel.hourly[index])),
                                        // image: AssetImage(
                                        //     "asset/image/thunderstorm.png"),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.access_time_rounded,
                                            color: ColorConfig.mainColor,
                                            size: 10,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 4),
                                            child: Text(
                                                ConvertHelper.milisToHour(weatherForecastModel
                                                    .hourly[index].dt),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: ColorConfig.textColorLight,
                                                    fontFamily: 'NunitoRegular',
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 16),
                                      child: Text(
                                          weatherForecastModel.hourly[index].temp
                                                  .toStringAsFixed(1) +
                                              "°C",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: ColorConfig.textColorLight,
                                              fontFamily: 'NunitoBold',
                                          )),
                                    )
                                  ],
                                ),
                                margin: EdgeInsets.only(left: 8, right: 8),
                              ),
                            ),
                          ),
                        );
                      }),
                )
              : Container()
        ],
      ),
    );
  }

  Widget newsContainer() {

    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 8),
      child: StreamBuilder(
        stream: homeService.getNewsFromRss().asStream(),
        builder: (contex, AsyncSnapshot<RssFeed> snapshot) {
          if(snapshot.hasData) {

              var itemsList = snapshot.data.items.where((i) => i.description.toLowerCase().contains("cuaca")).toList();

            print("item list");
            print(itemsList.first);
            print(itemsList.first.enclosure.url);
            print(itemsList.first.link);

            return Container(
              height: 140,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Berita Cuaca", style: TextStyle(
                          fontSize: 16,
                          color: ColorConfig.textLabelDark,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NunitoBold',
                        )),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'NunitoBold',),
                          ),
                          onPressed: () {
                            this.gotoListNews();
                          },
                          child: Text('Lihat Semua',
                              style: TextStyle(
                                color: ColorConfig.mainColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NunitoBold',
                              )),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: 100,
                      child: ListView.builder(
                        itemCount: itemsList.length != null ? 3 : itemsList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, idx) {

                          var items = itemsList[idx];
                          var dateFormat = new DateFormat('EEEE, dd MMMM yyyy', "id_ID");
                          var fixedDate = dateFormat.format(items.pubDate);

                          return Container(
                            width: 300,
                            margin: EdgeInsets.only(right: 8),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                highlightColor: ColorConfig.mainColor.withOpacity(.2),
                                splashColor: ColorConfig.mainColor.withOpacity(.2),
                                onTap: () => {this.gotoDetailNews(items.link)},
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      child: Image(
                                        width: 100,
                                        image: NetworkImage(items.enclosure.url),
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 8, right: 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(items.title, style: TextStyle(
                                                fontSize: 12,
                                                color: ColorConfig.textColorLight,
                                                fontFamily: 'NunitoBold'
                                            ),
                                              maxLines: 2,
                                            ),
                                            Padding(
                                              child: Text(fixedDate, style: TextStyle(
                                                  fontSize: 11,
                                                  color: ColorConfig.textLabelDark,
                                                  fontFamily: 'NunitoRegular'
                                              ),
                                                maxLines: 1,
                                              ),
                                              padding: EdgeInsets.only(top: 8),
                                            ),
                                          ],
                                        ),
                                      ),

                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString(), style: TextStyle(
                  color: Colors.white
              )),
            );
          }

          return Container();
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.darkBackgroundColor,
        body: Container(
          child: RefreshIndicator(
            color: ColorConfig.mainColor,
            onRefresh: () {
              return Future.delayed(Duration(milliseconds: 500), () {
                getCurrentLocation();
              });
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  header(),
                  weather(),
                  todayContainer(),
                  newsContainer()
                ],
              ),
            ),
          ),
        ));
  }
}

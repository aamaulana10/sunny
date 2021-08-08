import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sunny/config/color/colorConfig.dart';
import 'package:sunny/config/helper/conditionHelper.dart';
import 'package:sunny/config/helper/convertHelper.dart';
import 'package:sunny/feature/home/model/weatherForecastModel.dart';
import 'package:sunny/feature/home/service/homeService.dart';
import 'package:sunny/feature/mainTabbar/mainTabbar.dart';
import 'package:sunny/feature/weatherList/view/weatherListView.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeService homeService = HomeService();

  WeatherForecastModel weatherForecastModel = WeatherForecastModel();
  bool isLoading = true;

  var address = "";
  var isForecast = true;

  void gotoDetail() {
    print("detail view");
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
      print(value);

      setState(() {
        weatherForecastModel = value;
        isLoading = false;
      });
    });
  }

  void gotoFullReport() {
    Navigator.of(context).pushReplacement(
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

    super.initState();
  }

  Widget header() {
    var dateFormat = new DateFormat('EEEE, dd MMMM yyyy');

    var currentDate = dateFormat.format(DateTime.now().toLocal());

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
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            child: Text(
              currentDate.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 8, right: 8, top: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 8),
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isForecast == true
                        ? ColorConfig.mainColor
                        : Colors.grey.withOpacity(0.1),
                  ),
                  child: FlatButton(
                    minWidth: 100,
                    height: 40,
                    onPressed: () {
                      setState(() {
                        isForecast = true;
                      });
                    },
                    child: Text(
                      "Forecast",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 8),
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isForecast == false
                        ? ColorConfig.mainColor
                        : Colors.grey.withOpacity(0.1),
                  ),
                  child: FlatButton(
                    minWidth: 100,
                    height: 40,
                    onPressed: () {
                      setState(() {
                        isForecast = false;
                      });
                    },
                    child: Text(
                      "Air Quality",
                      style: TextStyle(
                        color: Colors.white,
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
            valueColor: AlwaysStoppedAnimation<Color>(ColorConfig.mainColor),
          ),
        ),
      );
    } else {
      if (weatherForecastModel != null) {
        var temp = weatherForecastModel.current.temp;

        var wind = ConvertHelper.milToKmPerHour(weatherForecastModel.current.windSpeed);

        var humidity = weatherForecastModel.current.humidity;

        return Container(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Image(
                    image: AssetImage(ConditionHelper.getIcon(weatherForecastModel))),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage("asset/image/fluenttemperature.png"),
                      height: 40,
                      width: 40,
                    ),
                    Text(
                        weatherForecastModel.current.temp.toStringAsFixed(1) +
                            "°C",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Text(
                    ConditionHelper.getDescription(weatherForecastModel),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
              ),
              isForecast == true
                  ? Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 32),
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
                                  image: AssetImage(ConditionHelper.getIconDaily(0, weatherForecastModel)),
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text(ConvertHelper.milisToDay(weatherForecastModel.daily[0].dt),
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            "asset/image/fluenttemperature.png"),
                                        height: 24,
                                        width: 24,
                                      ),
                                      Text(
                                          weatherForecastModel.daily[0].temp.day
                                                  .toStringAsFixed(1) +
                                              "°C",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
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
                                  image: AssetImage(ConditionHelper.getIconDaily(1, weatherForecastModel)),
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text(ConvertHelper.milisToDay(weatherForecastModel.daily[1].dt),
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            "asset/image/fluenttemperature.png"),
                                        height: 24,
                                        width: 24,
                                      ),
                                      Text(
                                          weatherForecastModel.daily[1].temp.day
                                                  .toStringAsFixed(1) +
                                              "°C",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
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
                      margin: EdgeInsets.only(left: 8, right: 8, top: 32),
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
                                    padding: EdgeInsets.only(left: 4),
                                    child: Text("Kecepatan Angin",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image(
                                        image:
                                            AssetImage("asset/image/speed.png"),
                                        height: 24,
                                        width: 24,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 4),
                                        child: Text(wind + " km/j",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
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
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text("Kelembapan",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            "asset/image/waterpercent.png"),
                                        height: 24,
                                        width: 24,
                                      ),
                                      Text(humidity.toStringAsFixed(1) + " %",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
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
            margin: EdgeInsets.only(top: 32, right: 8, left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hari Ini",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  onPressed: () {
                    this.gotoFullReport();
                  },
                  child: Text('Lihat Laporan',
                      style: TextStyle(
                          color: ColorConfig.mainColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          weatherForecastModel.hourly != null
              ? Container(
                  height: 180,
                  margin: EdgeInsets.only(top: 8, bottom: 8),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(
                              left: 8, right: 8, top: 4, bottom: 4),
                          margin: EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(0.2)),
                          width: 150,
                          child: InkWell(
                            onTap: () => {this.gotoDetail()},
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 8),
                                    height: 80,
                                    child: Image(
                                      image: AssetImage(ConditionHelper.getIconHourly(index, weatherForecastModel)),
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
                                          size: 18,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 4),
                                          child: Text(
                                              ConvertHelper.milisToHour(weatherForecastModel
                                                  .hourly[index].dt),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white)),
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
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  )
                                ],
                              ),
                              margin: EdgeInsets.only(left: 8, right: 8),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConfig.darkBackgroundColor,
        body: Container(
          child: RefreshIndicator(
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
                ],
              ),
            ),
          ),
        ));
  }
}

import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunny/config/color/colorConfig.dart';
import 'package:sunny/config/extension/stringExtension.dart';
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
          address = "${place.locality} ${place.country}";
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

    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
      MainTabbar(selectedIndex: 2)
    ));
  }

  @override
  void initState() {

    getCurrentLocation();

    super.initState();
  }

  Widget header() {
    var dateFormat = new DateFormat('MMM dd, yyyy');

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
                        ? Colors.blue[700]
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
                        ? Colors.blue[700]
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
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      if (weatherForecastModel != null) {
        var temp = weatherForecastModel.current.temp;

        var wind = milToKmPerHour(weatherForecastModel.current.windSpeed);

        var humidity = weatherForecastModel.current.humidity;

        if (isForecast == true) {
          return Container(
            height: 200,
            child: Column(
              children: [
                Container(
                  height: 100,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 16, right: 16, top: 24),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent),
                  child: Text(
                      weatherForecastModel.current.temp.toStringAsFixed(1) +
                          "°",
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF3D76FF),
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent),
                  child: Text(
                      weatherForecastModel.hourly[0].weather[0].description,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                )
              ],
            ),
          );
        } else {
          return Container(
            height: 200,
            margin: EdgeInsets.only(left: 16, right: 16, top: 24),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                  Container(
                    width: MediaQuery.of(context).size.width -80,
                    margin: EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage("asset/image/thermometer.png"),
                        height: 80,
                          width: 80,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "Temperature",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Text(
                            temp.toStringAsFixed(1) + "° C",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
            Container(
              width: MediaQuery.of(context).size.width -80,
                    margin: EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)
              ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage("asset/image/wind.png"),
                          height: 80,
                          width: 80,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "Wind Speed",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Text(
                            wind + "Km/h",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                Container(
                  width: MediaQuery.of(context).size.width -80,
                  margin: EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10)
                  ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage("asset/image/humidity.png"),
                          height: 80,
                          width: 80,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "Humidity",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Text(
                            humidity.toString() + "%",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                ),
              ],
            ),
          );
        }
      } else {
        return Container();
      }
    }
  }

  String kelvinToCelcius(double temp) {
    if (temp != null) {
      var fixedvalue = temp - 273.15;

      return fixedvalue.toStringAsFixed(1);
    } else {
      return "0";
    }
  }

  String milToKmPerHour(double wind) {
    if (wind != null) {
      var fixedValue = wind * 1.609;

      return fixedValue.toStringAsFixed(1);
    } else {
      return "0";
    }
  }

  String milisToHour(int milis) {
    var fixedValue = DateTime.fromMillisecondsSinceEpoch(milis * 1000);

    var dateFormat = new DateFormat('HH.mm');

    var currentDate = dateFormat.format(fixedValue);

    return currentDate;
  }

  Widget todayContainer() {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 8, right: 8, left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  onPressed: () {
                    this.gotoFullReport();
                  },
                  child: const Text('Full Report'),
                ),
              ],
            ),
          ),
          weatherForecastModel.hourly != null
              ? Container(
                  height: 80,
                  margin: EdgeInsets.only(top: 8, left: 8, right: 8),
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
                              color: Colors.grey.withOpacity(0.1)),
                          width: 150,
                          child: InkWell(
                            onTap: () => {this.gotoDetail()},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image(
                                  image: NetworkImage(
                                      "https://openweathermap.org/img/wn/" +
                                          weatherForecastModel
                                              .hourly[index].weather[0].icon +
                                          "@2x.png"),
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          milisToHour(weatherForecastModel
                                              .hourly[index].dt),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white)),
                                      Text(
                                          weatherForecastModel
                                                  .hourly[index].temp
                                                  .toStringAsFixed(1) +
                                              "°",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white))
                                    ],
                                  ),
                                  margin: EdgeInsets.only(left: 8, right: 8),
                                ),
                              ],
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
              return Future.delayed(Duration(seconds: 1), () {
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

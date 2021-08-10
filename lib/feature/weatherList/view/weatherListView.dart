import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:intl/intl.dart';
import 'package:sunny/config/color/colorConfig.dart';
import 'package:sunny/config/helper/conditionHelper.dart';
import 'package:sunny/config/helper/convertHelper.dart';
import 'package:sunny/feature/detailForecast/view/DetailForecastHourly.dart';
import 'package:sunny/feature/detailForecast/view/detailForecastDaily.dart';
import 'package:sunny/feature/home/model/weatherForecastModel.dart';
import 'package:sunny/feature/home/service/homeService.dart';

class WeatherListView extends StatefulWidget {
  @override
  _WeatherListViewState createState() => _WeatherListViewState();
}

class _WeatherListViewState extends State<WeatherListView> {
  HomeService homeService = HomeService();
  bool isLoading = true;
  WeatherForecastModel weatherForecastModel = WeatherForecastModel();

  var address = "";

  void gotoDetailHourly(Hourly weatherHourly) {

    print("detail view");

    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
        DetailForecastHourly(
          weatherHourly: weatherHourly,
          address: address,
        )
    )
    );
  }

  void gotoDetailDaily(Daily weatherDaily) {
    
    print("detail view");

    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
        DetailForecastDaily(
          weatherDaily: weatherDaily,
          address: address,
        )
    )
    );
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
    setState(() {
      isLoading = true;
    });

    homeService.getCurrentWeatherByLatLong(latitude, longitude).then((value) {
      print(value);

      setState(() {
        weatherForecastModel = value;
      });

      if (value.hourly != null) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    getCurrentLocation();

    super.initState();
  }

  Widget header() {
    var dateFormat = new DateFormat('EEEE, dd MMMM yyyy');

    var currentDate = dateFormat.format(DateTime.now());

    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 130,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("asset/image/weatherHeader.png"),
                  fit: BoxFit.fill
                ),
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 8, right: 16, top: 16, bottom: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          child: Text(currentDate,
                              style:
                                  TextStyle(color: ColorConfig.textColorLight, fontSize: 18)),
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image(
                              image: AssetImage(
                                  "asset/image/fluenttemperaturewhite.png"),
                              height: 33,
                              width: 33,
                            ),
                            Text(
                                weatherForecastModel.current != null ? weatherForecastModel.current.temp
                                        .toStringAsFixed(1) +
                                    "°C" : "",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConfig.textColorLight,
                                )),
                          ],
                        ),
                        Padding(
                          child: Text(
                            weatherForecastModel.current != null ?
                              ConditionHelper.getDescription(
                                  weatherForecastModel.current) : "",
                              style: TextStyle(
                                  color: ColorConfig.textColorLight,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal)),
                          padding: EdgeInsets.only(left: 12),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  width: 100,
                  child: Image(
                      image: AssetImage(
                        weatherForecastModel.current != null ?
                          ConditionHelper.getIcon(weatherForecastModel.current) : "asset/image/sunny.png")),
                )
              ],
            ),
          ),
          weatherForecastModel.hourly != null
              ? Container(
                  height: 130,
                  margin: EdgeInsets.only(top: 16, right: 8),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: weatherForecastModel.hourly.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(
                              left: 8, right: 8,bottom: 4),
                          margin: EdgeInsets.only(left: 4, right: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorConfig.colorWidget),
                          width: 90,
                          child: InkWell(
                            onTap: () => {this.gotoDetailHourly(weatherForecastModel.hourly[index])},
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 8),
                                    height: 53,
                                    width: 53,
                                    child: Image(
                                      image: AssetImage(
                                          ConditionHelper.getIconHourly(weatherForecastModel.hourly[index])),
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
                                              ConvertHelper.milisToHour(
                                                  weatherForecastModel
                                                      .hourly[index].dt),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: ColorConfig.textColorLight)),
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
                                            color: ColorConfig.textColorLight)),
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

  Widget nextForecaseList() {

    double listHeight = 40 + (weatherForecastModel.daily != null
        ? weatherForecastModel.daily.length.toDouble() * 100
        : 1000.toDouble());

    if(weatherForecastModel.daily != null) {
      return Container(
          height: listHeight,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 32, right: 16, left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Perkiraan Cuaca Selanjutnya",
                      style: TextStyle(
                          color: ColorConfig.textColorLight,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              weatherForecastModel.daily != null
                  ? Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: weatherForecastModel.daily.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => {this.gotoDetailDaily(weatherForecastModel.daily[index])},
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(width: 1, color: Color(0XFF313131))
                                )
                            ),
                            margin:
                            EdgeInsets.only(left: 8, right: 8, bottom: 8),
                            padding: EdgeInsets.only(top: 8,bottom: 16),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      ConvertHelper.milisToDay(
                                          weatherForecastModel.daily[index].dt),
                                      style: TextStyle(color: ColorConfig.textColorLight,
                                          fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 8),
                                      child: Text(
                                        ConvertHelper.milisToDate(
                                            weatherForecastModel
                                                .daily[index].dt),
                                        style: TextStyle(color: ColorConfig.textColorLight, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            "asset/image/fluenttemperature.png"),
                                        height: 26,
                                        width: 26,
                                      ),
                                      Text(
                                          weatherForecastModel
                                              .daily[index].temp.max
                                              .toStringAsFixed(1) +
                                              "°C",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28,
                                              color: ColorConfig.textColorLight)),
                                    ],
                                  ),
                                ),
                                Image(
                                  image: AssetImage(
                                      ConditionHelper.getIconDaily(weatherForecastModel.daily[index])),
                                  width: 53,
                                  height: 53,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              )
                  : Expanded(child: Container())
            ],
          ));
    } else {

      return Container(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(ColorConfig.mainColor),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConfig.darkBackgroundColor,
        body: Container(
          padding: EdgeInsets.only(top: 32),
          child: RefreshIndicator(
            color: ColorConfig.mainColor,
            onRefresh: () {
              return Future.delayed(Duration(seconds: 1), () {
                getCurrentLocation();
              });
            },
            child: SingleChildScrollView(
              child: Column(
                  children: [header(), nextForecaseList()],
                ),
            ),
          ),
        ));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sunny/core/config/color/colorConfig.dart';
import 'package:sunny/core/config/helper/conditionHelper.dart';
import 'package:sunny/core/config/helper/convertHelper.dart';
import 'package:sunny/core/model/weatherForecastModel.dart';
import 'package:sunny/core/service/weatherService.dart';
import 'package:sunny/feature/detailForecast/view/detailForecastDaily.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;

class SearchView extends StatefulWidget {

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  HomeService homeService = HomeService();
  WeatherForecastModel weatherForecastModel = WeatherForecastModel();
  WeatherForecastModel weatherForecastColumns = WeatherForecastModel();

  var address = "Mendapatkan Lokasimu";
  var cityFromAddress = "";
  var locationInput = "";
  var isSearch = false;
  var isLoading = false;

  void gotoDetailDaily(Daily weatherDaily) {
    print("detail view");

    Future.delayed(Duration(milliseconds: 500)).then((value) {

      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          DetailForecastDaily(
            weatherDaily: weatherDaily,
            address: address,
          )
      )
      );
    });

  }

  void gotoDetailDailyFromList(Daily weatherDaily) {
    print("detail view");

    Future.delayed(Duration(milliseconds: 500)).then((value) {

      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          DetailForecastDaily(
            weatherDaily: weatherDaily,
            address: locationInput,
          )
      )
      );
    });

  }

  void setInputLocation(String location) {

    setState(() {
      locationInput = location;
      isSearch = false;
      weatherForecastModel = null;
    });

  }

  // pertama ini
  void getCurrentLocation() async {
    var position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    var lastPosition = await Geolocator().getLastKnownPosition();
    print(lastPosition);

    print("$position.latitude, $position.longitude");

    if (position.latitude != null || position.longitude != null) {

      _getAddressFromLatLng(position.latitude, position.longitude);
      getUserForecast(position.latitude.toString(), position.longitude.toString());
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
          cityFromAddress = "${place.locality}";
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // kedua ini
  void getUserForecast(String latitude, String longitude) {

    homeService.getCurrentWeatherByLatLong(latitude, longitude).then((value) {

      setState(() {
        weatherForecastModel = value;
      });
    });
  }

  void getCurrentWeather(String city) {

    FocusScope.of(context).unfocus();

    setState(() {
      isSearch = true;
      isLoading = true;
    });

    homeService.getCurrentWeatherByCity(city).then((value) {

      homeService.getCurrentWeatherByLatLong(value.coord.lat.toString(),
          value.coord.lon.toString()).then((forecast) {

        setState(() {
          weatherForecastModel = forecast;
          isLoading = false;
        });

      });

    }).onError((error, stackTrace) {

      setState(() {
        isLoading = false;
        weatherForecastColumns = null;
      });

      print("error search");
      print(error);
    });
  }

  @override
  void initState() {

    getCurrentLocation();

    super.initState();
  }

  Widget header() {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   margin: EdgeInsets.only(top: 16, left: 16, right: 16),
          //   child: Text("Find the area or city that you want to know the detailed weather info at this time",
          //     maxLines: 2,
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       color: ColorConfig.textColorLight,
          //       fontSize: 14,
          //     ),),
          // ),
          Container(
              margin: EdgeInsets.only(top: 24),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        margin: EdgeInsets.only(right: 8,left: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10), color: ColorConfig.colorWidget),
                        child: TextFormField(
                          onChanged: (e) => {
                            this.setInputLocation(e)
                          },
                          onEditingComplete: () => {

                             getCurrentWeather(locationInput)
                          },
                          style: TextStyle(
                              color: ColorConfig.textColorLight,
                              fontFamily: 'NunitoRegular'
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search, color: Colors.white, size: 22,),
                              labelText: "Cari Lokasi",
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              labelStyle: TextStyle(
                                color: ColorConfig.textLabelDark,
                                fontSize: 12,
                                  fontFamily: 'NunitoRegular'
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    )
                  ]
              )),
          Container(
            margin: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Text("Lokasi Saat ini", style: TextStyle(
                color: ColorConfig.textLabelDark,
              fontWeight: FontWeight.w700,
                fontFamily: 'NunitoBold'
            ))
          ),
          InkWell(
            onTap: () => {getCurrentWeather(cityFromAddress)},
            child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                child: Text(address, style: TextStyle(
                    color: ColorConfig.textLabelDark,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'NunitoRegular'
                ))
            ),
          ),
        ],
      ),
    );
  }

  Widget weatherColumn() {

    if(weatherForecastColumns != null && weatherForecastColumns.hourly != null) {

      return Container(
        height: 400,
        child: Stack(
          children: [
            Positioned(
                top: 8,
                left: 16,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorConfig.colorWidget),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 8, right: 8, top: 16),
                        height: 60,
                        width: (MediaQuery
                            .of(context)
                            .size
                            .width / 2) - 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Text(weatherForecastColumns.hourly[0].temp
                                      .toStringAsFixed(1) + "°",
                                    style: TextStyle(
                                      color: ColorConfig.textColorLight,
                                      fontSize: 16,
                                      fontFamily: 'NunitoBold'
                                    ),),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(weatherForecastColumns.hourly[0]
                                        .weather[0].main, style: TextStyle(
                                      color: ColorConfig.textColorLight,
                                      fontSize: 16,
                                        fontFamily: 'NunitoRegular'
                                    ),),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Image(
                                  fit: BoxFit.fill,
                                  width: 50,
                                  image: NetworkImage(
                                      "https://openweathermap.org/img/wn/" +
                                          weatherForecastColumns
                                              .hourly[0].weather[0].icon +
                                          "@2x.png")),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 8, bottom: 8),
                        child: Text("California", style: TextStyle(
                          color: ColorConfig.textColorLight,
                          fontSize: 16,
                            fontFamily: 'NunitoRegular'
                        ),),
                      )
                    ],
                  ),
                )),
            Positioned(
                top: 32,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorConfig.colorWidget),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 8, right: 8, top: 16),
                        height: 60,
                        width: (MediaQuery
                            .of(context)
                            .size
                            .width / 2) - 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Text("32°", style: TextStyle(
                                    color: ColorConfig.textColorLight,
                                    fontSize: 16,
                                      fontFamily: 'NunitoBold'
                                  ),),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text("Cloudy", style: TextStyle(
                                      color: ColorConfig.textColorLight,
                                      fontSize: 16,
                                        fontFamily: 'NunitoBold'
                                    ),),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Image(
                                  fit: BoxFit.fill,
                                  width: 50,
                                  image: NetworkImage(
                                      "https://openweathermap.org/img/wn/" +
                                          weatherForecastColumns
                                              .hourly[1].weather[0].icon +
                                          "@2x.png")),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 8, bottom: 8),
                        child: Text("California", style: TextStyle(
                          color: ColorConfig.textColorLight,
                          fontSize: 16,
                            fontFamily: 'NunitoRegular'
                        ),),
                      )
                    ],
                  ),
                )),

            Positioned(
                top: 120,
                left: 16,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorConfig.colorWidget),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 8, right: 8, top: 16),
                        height: 60,
                        width: (MediaQuery
                            .of(context)
                            .size
                            .width / 2) - 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Text("32°", style: TextStyle(
                                    color: ColorConfig.textColorLight,
                                    fontSize: 16,
                                      fontFamily: 'NunitoBold'
                                  ),),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text("Cloudy", style: TextStyle(
                                      color: ColorConfig.textColorLight,
                                      fontSize: 16,
                                        fontFamily: 'NunitoBold'
                                    ),),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Image(
                                  fit: BoxFit.fill,
                                  width: 50,
                                  image: NetworkImage(
                                      "https://openweathermap.org/img/wn/" +
                                          weatherForecastColumns
                                              .hourly[2].weather[0].icon +
                                          "@2x.png")),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 8, bottom: 8),
                        child: Text("California", style: TextStyle(
                          color: ColorConfig.textColorLight,
                          fontSize: 16,
                            fontFamily: 'NunitoRegular'
                        ),),
                      )
                    ],
                  ),
                )),

            Positioned(
                top: 144,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorConfig.colorWidget),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 8, right: 8, top: 16),
                        height: 60,
                        width: (MediaQuery
                            .of(context)
                            .size
                            .width / 2) - 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Text("32°", style: TextStyle(
                                    color: ColorConfig.textColorLight,
                                    fontSize: 16,
                                      fontFamily: 'NunitoBold'
                                  ),),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text("Cloudy", style: TextStyle(
                                      color: ColorConfig.textColorLight,
                                      fontSize: 16,
                                        fontFamily: 'NunitoBold'
                                    ),),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Image(
                                  fit: BoxFit.fill,
                                  width: 50,
                                  image: NetworkImage(
                                      "https://openweathermap.org/img/wn/" +
                                          weatherForecastColumns
                                              .hourly[3].weather[0].icon +
                                          "@2x.png")),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 8, bottom: 8),
                        child: Text("California", style: TextStyle(
                          color: ColorConfig.textColorLight,
                          fontSize: 16,
                            fontFamily: 'NunitoRegular'
                        ),),
                      )
                    ],
                  ),
                )),
          ],
        ),
      );
    } else {

      return Container();
    }
  }

  Widget nextForecaseList() {
    var dateFormat = new DateFormat('MMM, dd');

    var currentDate = dateFormat.format(DateTime.now());

    if(isLoading == true) {

      return Container(
        child: Container(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(ColorConfig.mainColor),
            ),
          ),
        )
      );
    } else {
      if (weatherForecastModel != null && weatherForecastModel.hourly != null) {
        return Container(
          margin: EdgeInsets.only(top: 0, left: 8, right: 8),
          child: ListView.builder(
              itemCount: weatherForecastModel.daily.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Color(0XFF313131))
                      )
                  ),
                  margin:
                  EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: InkWell(
                    onTap: () => {this.gotoDetailDailyFromList(weatherForecastModel.daily[index])},
                    highlightColor: ColorConfig.mainColor.withOpacity(.2),
                    splashColor: ColorConfig.mainColor.withOpacity(.2),
                    child: Container(
                      padding: EdgeInsets.only(top: 8,bottom: 16),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                ConvertHelper.milisToDay(
                                    weatherForecastModel.daily[index].dt),
                                style: TextStyle(color: ColorConfig.textColorLight,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NunitoBold',
                                    fontSize: 14),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                child: Text(
                                  ConvertHelper.milisToDate(
                                      weatherForecastModel
                                          .daily[index].dt),
                                  style: TextStyle(
                                      color: ColorConfig.textColorLight,
                                      fontSize: 12,
                                      fontFamily: 'NunitoRegular'
                                  ),
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
                                        color: ColorConfig.textColorLight,
                                        fontFamily: 'NunitoBold'
                                    )),
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
                  ),
                );
              }),
        );
      }

      else {
        return Container(
          child: Center(
            child: Text("Data tidak ditemukan", style: TextStyle(
              color: ColorConfig.textLabelColor,
                fontFamily: 'NunitoRegular'
            )),
          ),
        );
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.darkBackgroundColor,
      body: Container(
        margin: EdgeInsets.only(top: 16),
        child: Column(
            children: [
              header(),
              isSearch == false ?
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 32, right: 32),
                    child: Text("Masukkan atau pilih Lokasi kamu saat ini untuk melihat perkiraan cuaca", style: TextStyle(
                      color: ColorConfig.textLabelColor,
                    ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ) :
                  Expanded(child: nextForecaseList())
            ],
          ),
      ),
    );
  }
}
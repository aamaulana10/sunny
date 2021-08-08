import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sunny/config/color/colorConfig.dart';
import 'package:sunny/config/helper/convertHelper.dart';
import 'package:sunny/feature/home/model/weatherForecastModel.dart';
import 'package:sunny/feature/home/service/homeService.dart';
import 'package:geolocator/geolocator.dart';

class SearchView extends StatefulWidget {

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  HomeService homeService = HomeService();
  WeatherForecastModel weatherForecastModel = WeatherForecastModel();
  WeatherForecastModel weatherForecastColumns = WeatherForecastModel();
  var locationInput = "";
  var isSearch = false;

  void gotoDetail() {
    print("detail view");
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

      getUserForecast(position.latitude.toString(), position.longitude.toString());
    }
  }


  // kedua ini
  void getUserForecast(String latitude, String longitude) {

    homeService.getCurrentWeatherByLatLong(latitude, longitude).then((value) {
      print(value);

      setState(() {
        weatherForecastColumns = value;
      });
    });
  }

  void getCurrentWeather(String city) {

    FocusScope.of(context).unfocus();

    setState(() {
      isSearch = true;
    });

    homeService.getCurrentWeatherByCity(city).then((value) {

      homeService.getCurrentWeatherByLatLong(value.coord.lat.toString(),
          value.coord.lon.toString()).then((forecast) {

        setState(() {
          weatherForecastModel = forecast;
        });

      });
    });
  }

  @override
  void initState() {

    super.initState();
  }

  Widget header() {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Text("Find the area or city that you want to know the detailed weather info at this time",
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorConfig.textColorLight,
                fontSize: 14,
              ),),
          ),
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
                              color: ColorConfig.textColorLight
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search, color: Colors.white, size: 24,),
                              labelText: "Search",
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              labelStyle: TextStyle(
                                color: ColorConfig.textColorLight,
                                fontSize: 12,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), color: ColorConfig.colorWidget),
                      child: IconButton(
                          iconSize: 24,
                          color: ColorConfig.textColorLight,
                          icon: Icon(Icons.location_on),
                          onPressed: () => {print("press")}),
                    ),
                  ]
              )),
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
                                    ),),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(weatherForecastColumns.hourly[0]
                                        .weather[0].main, style: TextStyle(
                                      color: ColorConfig.textColorLight,
                                      fontSize: 16,
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
                                  ),),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text("Cloudy", style: TextStyle(
                                      color: ColorConfig.textColorLight,
                                      fontSize: 16,
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
                                  ),),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text("Cloudy", style: TextStyle(
                                      color: ColorConfig.textColorLight,
                                      fontSize: 16,
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
                                  ),),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text("Cloudy", style: TextStyle(
                                      color: ColorConfig.textColorLight,
                                      fontSize: 16,
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
                        ),),
                      )
                    ],
                  ),
                )),
          ],
        ),
      );
    } else {

      print("kesini ga ?");

      return Container();
    }
  }

  Widget nextForecaseList() {
    var dateFormat = new DateFormat('MMM, dd');

    var currentDate = dateFormat.format(DateTime.now());

    if (weatherForecastModel != null && weatherForecastModel.hourly != null) {

      return Container(
        margin: EdgeInsets.only(top: 0, left: 8, right: 8),
        child: ListView.builder(
            itemCount: weatherForecastModel.hourly.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => {this.gotoDetail()},
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorConfig.colorWidget,
                      borderRadius: BorderRadius.circular(8)),
                  margin: EdgeInsets.only(left: 8, right: 8, bottom: 4),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            ConvertHelper.milisToDay(weatherForecastModel.hourly[index].dt),
                            style: TextStyle(
                                color: ColorConfig.textColorLight,
                                fontSize: 12
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Text(
                              ConvertHelper.milisToDate(weatherForecastModel.hourly[index].dt),
                              style: TextStyle(
                                color: ColorConfig.textColorLight,
                                fontSize: 12
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Text(
                            weatherForecastModel.hourly[index].temp
                                .toStringAsFixed(1) +
                                "°",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 32, color: ColorConfig.textColorLight)),
                      ),
                      Image(
                        image: NetworkImage(
                            "https://openweathermap.org/img/wn/" +
                                weatherForecastModel
                                    .hourly[0].weather[0].icon +
                                "@2x.png"),
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              );
            }),
      );
    }

    else {

      return Container();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConfig.darkBackgroundColor,
        centerTitle: true,
        title: Text("Pick Location", style: TextStyle(
            color: ColorConfig.textColorLight,
            fontSize: 24,
            fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: ColorConfig.darkBackgroundColor,
      body: Container(
        margin: EdgeInsets.only(top: 16),
        child: Column(
            children: [
              header(),
              isSearch == false ?
                Container() :
                  Expanded(child: nextForecaseList())
            ],
          ),
      ),
    );
  }
}
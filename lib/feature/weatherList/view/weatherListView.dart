import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sunny/config/color/colorConfig.dart';
import 'package:sunny/config/helper/timeHelper.dart';
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

  void gotoDetail() {
    print("detail view");
  }

  void getForecast() {
    setState(() {
      isLoading = true;
    });

    homeService.getCurrentWeatherByLatLong("-6.1781", "106.63").then((value) {
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

  Widget header() {
    var dateFormat = new DateFormat('MMM dd, yyyy');

    var currentDate = dateFormat.format(DateTime.now());

    String milisToHour(int milis) {
      var fixedValue = DateTime.fromMillisecondsSinceEpoch(milis * 1000);

      var dateFormat = new DateFormat('HH.mm');

      var currentDate = dateFormat.format(fixedValue);

      return currentDate;
    }

    return Container(
      height: 200,
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  currentDate.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          weatherForecastModel.hourly != null
              ? Container(
            height: 80,
            margin: EdgeInsets.only(top: 24, right: 8),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: weatherForecastModel.hourly.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => {this.gotoDetail()},
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      margin: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(0.1)),
                      width: 150,
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
                            width: 50,
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

  Widget nextForecaseList() {

    return Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 8, right: 16, left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Next Forecast",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            weatherForecastModel.daily != null
                ?
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                child: ListView.builder(
                  shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: weatherForecastModel.daily.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => {this.gotoDetail()},
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8)),
                          margin: EdgeInsets.only(left: 8, right: 8, bottom: 4),
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    TimeHelper.milisToDay(weatherForecastModel.daily[index].dt),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 8),
                                    child: Text(
                                      TimeHelper.milisToDate(weatherForecastModel.daily[index].dt),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Text(
                                    weatherForecastModel.daily[index].temp.max
                                        .toStringAsFixed(1) +
                                        "°",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 32, color: Colors.white)),
                              ),
                              Image(
                                image: NetworkImage(
                                    "https://openweathermap.org/img/wn/" +
                                        weatherForecastModel
                                            .daily[index].weather[0].icon +
                                        "@2x.png"),
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            )
                : Container()
          ],
        ));
  }

  @override
  void initState() {

    getForecast();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConfig.navigationBottomColor,
          centerTitle: true,
          title: Text("Forecast Report", style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color(0xFF0A214E),
        body: Container(
          child: RefreshIndicator(
            onRefresh: () {
              return Future.delayed(Duration(seconds: 1), () {
                getForecast();
              });
            },
            child:  Column(
                children: [header(), Expanded(child: nextForecaseList())],
              ),
            ),
        ));
  }
}
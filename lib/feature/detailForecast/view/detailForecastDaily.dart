import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sunny/config/color/colorConfig.dart';
import 'package:sunny/config/helper/conditionHelper.dart';
import 'package:sunny/config/helper/convertHelper.dart';
import 'package:sunny/feature/home/model/weatherForecastModel.dart';
import 'package:intl/date_symbol_data_local.dart';

class DetailForecastDaily extends StatefulWidget {

  Daily weatherDaily;
  String address;

  DetailForecastDaily({this.weatherDaily, this.address});

  @override
  _DetailForecastDailyState createState() => _DetailForecastDailyState();
}

class _DetailForecastDailyState extends State<DetailForecastDaily> {

  var isDay = true;

  @override
  void initState() {

    initializeDateFormatting();

    super.initState();
  }

  Widget itemList(String category, String content) {

    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 16, right: 16),
      height: 58,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 1, color: Color(0XFF313131))
          )
      ),
      child: Row(
          children: [
            Expanded(
              child: Text(category, style: TextStyle(
                  color: ColorConfig.textLabelColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal
              )),
            ),
            Text(content, style: TextStyle(
                color: ColorConfig.textColorLight,
                fontSize: 14,
                fontWeight: FontWeight.bold
            ))
          ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    var dateFormat = new DateFormat('EEEE, dd MMMM yyyy', "id_ID");

    var currentDate = dateFormat.format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConfig.darkBackgroundColor,
        title: Text(widget.address, style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white
            )
        ),
      ),
      backgroundColor: ColorConfig.darkBackgroundColor,
      body: Container(
        margin: EdgeInsets.only(top: 32),
        decoration: BoxDecoration(
            color: ColorConfig.colorWidget,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
        ),
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              height: 60,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0XFF313131))
                  )
              ),
              child: Text(currentDate, style: TextStyle(
                  color: ColorConfig.textColorLight,
                  fontSize: 14,
                  fontWeight: FontWeight.bold
              )),
            ),
            Container(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 8),
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: isDay == true
                                ? ColorConfig.mainColor
                                : ColorConfig.colorWidget,
                              border: isDay == true
                                  ? Border.all(color: ColorConfig.colorWidget, width: 1)
                                  : Border.all(color: ColorConfig.textLabelDark, width: 1)
                          ),
                          child: FlatButton(
                            minWidth: 100,
                            onPressed: () {
                              setState(() {
                                isDay = true;
                              });
                            },
                            child: Text(
                              "Siang",
                              style: TextStyle(
                                color: ColorConfig.textColorLight,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: isDay == false
                                ? ColorConfig.mainColor
                                : ColorConfig.colorWidget,
                            border: isDay == false
                                ? Border.all(color: ColorConfig.colorWidget, width: 1)
                                : Border.all(color: ColorConfig.textLabelDark, width: 1)
                          ),
                          child: FlatButton(
                            minWidth: 100,
                            onPressed: () {
                              setState(() {
                                isDay = false;
                              });
                            },
                            child: Text(
                              "Malam",
                              style: TextStyle(
                                color: ColorConfig.textColorLight,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage(ConditionHelper.getIconDaily(widget.weatherDaily)),
                        height: 90,
                        width: 90,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage("asset/image/fluenttemperature.png"),
                                  height: 33,
                                  width: 33,
                                ),
                                Text(
                                    isDay == true
                                    ? widget.weatherDaily.temp.day.toStringAsFixed(1) +
                                        "°C"
                                    :widget.weatherDaily.temp.night.toStringAsFixed(1) +
                                        "°C",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConfig.textLabelDark,
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Text(ConditionHelper.getDescriptionDaily(widget.weatherDaily), style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                            )),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            itemList("Matahari Terbit", ConvertHelper.milisToHour(widget.weatherDaily.sunrise)),
            itemList("Matahari Terbenam", ConvertHelper.milisToHour(widget.weatherDaily.sunset)),
            itemList("Temperatur", isDay == true
                ? widget.weatherDaily.temp.day.toStringAsFixed(1) +
                "°C"
                :widget.weatherDaily.temp.night.toStringAsFixed(1) +
                "°C",),
            itemList("Kelembapan", widget.weatherDaily.humidity.toStringAsFixed(0) + "%"),
            itemList("Arah Angin", widget.weatherDaily.windDeg.toString() + "°"),
            itemList("Kecepatan Angin", ConvertHelper.mToKmPerHour(widget.weatherDaily.windSpeed) + " km/j"),
            itemList("Hembusan Angin", ConvertHelper.mToKmPerHour(widget.weatherDaily.windGust) + " km/j"),
            itemList("Keadaan Mendung", widget.weatherDaily.clouds.toString() + "%"),
            itemList("Tekanan Udara", widget.weatherDaily.pressure.toString() + " hPa"),
            itemList("Jarak Pandang", widget.weatherDaily.visibility == null ? "Tidak diketahui" :
            ConvertHelper.mToKm(widget.weatherDaily.visibility) + " meter"),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sunny/config/color/colorConfig.dart';
import 'package:sunny/config/helper/conditionHelper.dart';
import 'package:sunny/config/helper/convertHelper.dart';
import 'package:sunny/feature/home/model/weatherForecastModel.dart';

class DetailForecastHourly extends StatefulWidget {

  Hourly weatherHourly;
  String address;

  DetailForecastHourly({this.weatherHourly, this.address});

  @override
  _DetailForecastHourlyState createState() => _DetailForecastHourlyState();
}

class _DetailForecastHourlyState extends State<DetailForecastHourly> {

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
                fontWeight: FontWeight.normal,
                fontFamily: 'NunitoRegular'
            )),
          ),
          Text(content, style: TextStyle(
              color: ColorConfig.textColorLight,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'NunitoBold'
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.address, style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorConfig.textColorLight,
                fontFamily: 'NunitoBold'
            )),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(currentDate, style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'NunitoRegular'
              )),
            )
          ],
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
                child: Text("Jam " + ConvertHelper.milisToHour(widget.weatherHourly.dt), style: TextStyle(
                  color: ColorConfig.textColorLight,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                    fontFamily: 'NunitoBold'
                )),
              ),
              Container(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage(ConditionHelper.getIconHourly(widget.weatherHourly)),
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
                                  widget.weatherHourly.temp.toStringAsFixed(1) +
                                      "°C",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConfig.textColorLight,
                                      fontFamily: 'NunitoBold'
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Text(ConditionHelper.getDescriptionHourly(widget.weatherHourly), style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                              fontFamily: 'NunitoBold'
                          )),
                        )
                      ],
                    )
                  ],
                ),
              ),
              itemList("Temperatur", widget.weatherHourly.temp.toStringAsFixed(1) + "°C"),
              itemList("Kelembapan", widget.weatherHourly.humidity.toStringAsFixed(0) + "%"),
              itemList("Arah Angin", widget.weatherHourly.windDeg.toString() + "°"),
              itemList("Kecepatan Angin", ConvertHelper.mToKmPerHour(widget.weatherHourly.windSpeed) + " km/j"),
              itemList("Hembusan Angin", ConvertHelper.mToKmPerHour(widget.weatherHourly.windGust) + " km/j"),
              itemList("Keadaan Mendung", widget.weatherHourly.clouds.toString() + "%"),
              itemList("Tekanan Udara", widget.weatherHourly.pressure.toString() + " hPa"),
              itemList("Jarak Pandang", widget.weatherHourly.visibility == null ? "Tidak diketahui" :
              ConvertHelper.mToKm(widget.weatherHourly.visibility) + " km"),
            ],
          ),
      ),
    );
  }
}

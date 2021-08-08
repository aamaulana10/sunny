import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sunny/config/color/colorConfig.dart';
import 'package:sunny/feature/home/view/HomeView.dart';
import 'package:sunny/feature/search/view/searchView.dart';
import 'package:sunny/feature/weatherList/view/weatherListView.dart';

class MainTabbar extends StatefulWidget {

  int selectedIndex;

  MainTabbar({this.selectedIndex});

  @override
  _MainTabbarState createState() => _MainTabbarState();
}

class _MainTabbarState extends State<MainTabbar> {

  var screen = [
    HomeView(),
    SearchView(),
    WeatherListView()
  ];

  var crntIndex = 0;

  void _onSelectedTab(value){

    setState(() {
      crntIndex = value;
    });
  }

  @override
  void initState() {

    if(widget.selectedIndex != null) {

      _onSelectedTab(widget.selectedIndex);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: crntIndex,
        children: screen,
      ),
      bottomNavigationBar : BottomNavigationBar(
        backgroundColor: ColorConfig.darkBackgroundColor,
        elevation: 5,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cari Lokasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny_sharp),
            label: 'Cuaca',
          ),
        ],
        currentIndex: crntIndex,
        unselectedItemColor: ColorConfig.textColorLight,
        selectedItemColor: ColorConfig.mainColor,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        onTap: (e) => {this._onSelectedTab(e)},
      ),
    );
  }
}

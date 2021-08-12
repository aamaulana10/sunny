import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
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
      bottomNavigationBar: BubbleBottomBar(
        hasNotch: true,
        backgroundColor: ColorConfig.darkBackgroundColor,
        opacity: .2,
        currentIndex: crntIndex,
        onTap: (e) => {_onSelectedTab(e)},
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(
                16)), //border radius doesn't work when the notch is enabled.
        elevation: 8,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: ColorConfig.mainColor,
              icon: Icon(
                Icons.home,
                color: ColorConfig.textColorLight,
              ),
              activeIcon: Icon(
                Icons.home,
                color: ColorConfig.mainColor,
              ),
              title: Text("Beranda",style: TextStyle(
                color: ColorConfig.mainColor,
                fontFamily: 'NunitoRegular',
                fontSize: 12,
              ),)),
          BubbleBottomBarItem(
              backgroundColor: ColorConfig.mainColor,
              icon: Icon(
                Icons.search,
                color: ColorConfig.textColorLight,
              ),
              activeIcon: Icon(
                Icons.search,
                color: ColorConfig.mainColor,
              ),
              title: Text("Cari Lokasi",style: TextStyle(
                color: ColorConfig.mainColor,
                fontFamily: 'NunitoRegular',
                fontSize: 12,
              ),)),
          BubbleBottomBarItem(
              backgroundColor: ColorConfig.mainColor,
              icon: Icon(
                Icons.wb_sunny_sharp,
                color: ColorConfig.textColorLight,
              ),
              activeIcon: Icon(
                Icons.wb_sunny_sharp,
                color: ColorConfig.mainColor,
              ),
              title: Text("Cuaca",style: TextStyle(
                color: ColorConfig.mainColor,
                fontFamily: 'NunitoRegular',
                fontSize: 12,
              ),)),
        ],
      ),
      // bottomNavigationBar : BottomNavigationBar(
      //   backgroundColor: ColorConfig.darkBackgroundColor,
      //   elevation: 5,
      //   type: BottomNavigationBarType.fixed,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Beranda',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.search),
      //       label: 'Cari Lokasi',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.wb_sunny_sharp),
      //       label: 'Cuaca',
      //     ),
      //   ],
      //   currentIndex: crntIndex,
      //   unselectedItemColor: ColorConfig.textColorLight,
      //   selectedItemColor: ColorConfig.mainColor,
      //   showUnselectedLabels: true,
      //   showSelectedLabels: true,
      //   onTap: (e) => {this._onSelectedTab(e)},
      // ),
    );
  }
}

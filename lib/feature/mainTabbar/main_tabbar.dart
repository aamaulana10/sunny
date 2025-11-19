import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:sunny/core/config/color/app_colors.dart';
import 'package:sunny/feature/home/view/home_view.dart';
import 'package:sunny/feature/search/view/search_view.dart';
import 'package:sunny/feature/weatherList/view/weather_list_view.dart';

// ignore: must_be_immutable
class MainTabbar extends StatefulWidget {
  int selectedIndex;

  MainTabbar({super.key, required this.selectedIndex});

  @override
  _MainTabbarState createState() => _MainTabbarState();
}

class _MainTabbarState extends State<MainTabbar> {
  var screen = [HomeView(), SearchView(), WeatherListView()];

  var crntIndex = 0;

  void _onSelectedTab(value) {
    setState(() {
      crntIndex = value;
    });
  }

  @override
  void initState() {
    if (widget.selectedIndex != null) {
      _onSelectedTab(widget.selectedIndex);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[crntIndex],
      bottomNavigationBar: BubbleBottomBar(
        hasNotch: true,
        backgroundColor: AppColors.darkBackgroundColor,
        opacity: .2,
        currentIndex: crntIndex,
        onTap: (e) => {_onSelectedTab(e)},
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ), //border radius doesn't work when the notch is enabled.
        elevation: 8,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
            backgroundColor: AppColors.mainColor,
            icon: Icon(Icons.home, color: AppColors.textColorLight),
            activeIcon: Icon(Icons.home, color: AppColors.mainColor),
            title: Text(
              "Beranda",
              style: TextStyle(
                color: AppColors.mainColor,
                fontFamily: 'NunitoRegular',
                fontSize: 12,
              ),
            ),
          ),
          BubbleBottomBarItem(
            backgroundColor: AppColors.mainColor,
            icon: Icon(Icons.search, color: AppColors.textColorLight),
            activeIcon: Icon(Icons.search, color: AppColors.mainColor),
            title: Text(
              "Cari Lokasi",
              style: TextStyle(
                color: AppColors.mainColor,
                fontFamily: 'NunitoRegular',
                fontSize: 12,
              ),
            ),
          ),
          BubbleBottomBarItem(
            backgroundColor: AppColors.mainColor,
            icon: Icon(Icons.wb_sunny_sharp, color: AppColors.textColorLight),
            activeIcon: Icon(Icons.wb_sunny_sharp, color: AppColors.mainColor),
            title: Text(
              "Cuaca",
              style: TextStyle(
                color: AppColors.mainColor,
                fontFamily: 'NunitoRegular',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar : BottomNavigationBar(
      //   backgroundColor: AppColors.darkBackgroundColor,
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
      //   unselectedItemColor: AppColors.textColorLight,
      //   selectedItemColor: AppColors.mainColor,
      //   showUnselectedLabels: true,
      //   showSelectedLabels: true,
      //   onTap: (e) => {this._onSelectedTab(e)},
      // ),
    );
  }
}

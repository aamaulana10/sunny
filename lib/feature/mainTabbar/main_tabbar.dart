import 'package:flutter/material.dart';
import 'package:sunny/core/config/color/app_colors.dart';
import 'package:sunny/feature/home/view/home_view.dart';
import 'package:sunny/feature/search/view/search_view.dart';
import 'package:sunny/feature/weatherList/view/weather_list_view.dart';

class MainTabbar extends StatefulWidget {
  final int selectedIndex;

  const MainTabbar({super.key, required this.selectedIndex});

  @override
  State<MainTabbar> createState() => _MainTabbarState();
}

class _MainTabbarState extends State<MainTabbar> {
  final List<Widget> _screens = [
    const HomeView(),
    const SearchView(),
    const WeatherListView(),
  ];

  late int _currentIndex;

  void _onSelectedTab(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: BottomNavigationBar(
            backgroundColor: AppColors.darkBackgroundColor,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: _onSelectedTab,
            selectedItemColor: AppColors.mainColor,
            unselectedItemColor: AppColors.textColorLight,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedLabelStyle: const TextStyle(
              fontFamily: 'NunitoRegular',
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(fontFamily: 'NunitoRegular'),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined),
                activeIcon: Icon(Icons.search),
                label: 'Cari Lokasi',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.wb_sunny_outlined),
                activeIcon: Icon(Icons.wb_sunny_sharp),
                label: 'Cuaca',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

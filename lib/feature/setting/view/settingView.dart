import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunny/config/color/colorConfig.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {

  bool isDarkMode = false;

  void usingFingerPrint() {

    print("finger print");
  }

  void setSwitchDarkMode(bool e) async{

    setState(() {
      isDarkMode = e;
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setBool("isDarkMode", isDarkMode);

    print(isDarkMode);

  }

  void checkDarkMode() async{

    SharedPreferences preferences = await SharedPreferences.getInstance();


    var darkMode = preferences.getBool("isDarkMode");

    print(darkMode);

      setState(() {
        isDarkMode = darkMode;
      });
  }

  void usingDarkMode() async{

    print("dark mode");
    setState(() {
      isDarkMode = !isDarkMode;
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setBool("isDarkMode", isDarkMode);

    var aa = preferences.getBool("isDarkMode");

    print(aa);

  }

  void saveLocation() {

    print("dark mode");
  }

  void exitApp() {

    print("dark mode");
  }

  @override
  void initState() {

    checkDarkMode();

    super.initState();
  }

  Widget settingList() {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8),
      padding: EdgeInsets.only(left: 8, right: 8),
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: 24),
            height: 80,
            child: InkWell(
              onTap: () => {this.usingFingerPrint()},
              child: Row(
                children: [
                  Icon(Icons.fingerprint, color: Colors.white),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      "Gunakan FingerPrint untuk membuka",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 80,
            child: InkWell(
              onTap: () => {this.usingDarkMode()},
              child: Row(
                children: [
                  Icon(Icons.nightlight_round, color: Colors.white),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Text(
                        "Dark Mode",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: 70,
                    child: Switch(value: isDarkMode, onChanged: (e) => {
                      this.setSwitchDarkMode(e)
                    }),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 80,
            child: InkWell(
              onTap: () => {this.saveLocation()},
              child: Row(
                children: [
                  Icon(Icons.lock, color: Colors.white),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      "Simpan Lokasimu",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 80,
            child: InkWell(
              onTap: () => {this.exitApp()},
              child: Row(
                children: [
                  Icon(Icons.exit_to_app, color: Colors.white),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      "Exit app",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 80,
              alignment: Alignment.bottomCenter,
              child: Text(
                "Develop by: Aressa Labs",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting",
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        backgroundColor: ColorConfig.navigationBottomColor,
      ),
      backgroundColor: Color(0xFF0A214E),
      body: Container(
        child: settingList(),
      ),
    );
  }
}

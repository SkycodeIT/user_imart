import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imart/const/asseth_path.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/const/user_token.dart';
import 'package:imart/ui_section/auth/login.dart';
import 'package:imart/ui_section/customer/tabbar/bottom_tabbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.cubeGrid;
  EasyLoading.instance.backgroundColor = MyTheme.accent_color;
  EasyLoading.instance.progressColor = const Color.fromRGBO(244, 223, 77, 1.0);
  EasyLoading.instance.indicatorColor = const Color.fromRGBO(244, 223, 77, 1.0);
  EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
  EasyLoading.instance.textColor = Colors.white;
  EasyLoading.instance.toastPosition = EasyLoadingToastPosition.bottom;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getKeys());
    if (prefs.getString("token") != null) {
      token = prefs.getString("token");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Scaffold(body: SplashScreen()),
      builder: EasyLoading.init(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      if (token == "null") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomTabbar()),
          (route) => false,
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.accent_color,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                ImagePath.icAppbarIcon,
              ),
              SizedBox(height: 20),
              Image.asset(
                ImagePath.icSplashTitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imart/const/asseth_path.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/const/user_token.dart';
import 'package:imart/ui_section/auth/login.dart';
import 'package:imart/ui_section/customer/drawer/aboutUs.dart';
import 'package:imart/ui_section/customer/drawer/legalPolicies.dart';
import 'package:imart/ui_section/customer/tabbar/bottom_tabbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({
    Key? key,
  }) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.only(top: 50),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Container(
                  height: 70,
                  width: 70,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
                title: const Text(
                  'Hello',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(153, 153, 153, 1),
                  ),
                ),
                subtitle: const Text(
                  'Green House',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(thickness: 1, height: 0),
              ),
              commonListTile(ImagePath.icProfile, 'Edit Profile', () {}),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(thickness: 1, height: 0),
              ),
              commonListTile(ImagePath.icOrder, 'My Orders', () {
                // Navigator.pop(context);
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  NoAnimationMaterialPageRoute(
                    builder: (context) => BottomTabbar(positionTab: 4),
                  ),
                  (route) => false,
                );
              }),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(thickness: 1, height: 0),
              ),
              commonListTile(ImagePath.icOffer, 'Offers', () {
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  NoAnimationMaterialPageRoute(
                    builder: (context) => BottomTabbar(positionTab: 3),
                  ),
                  (route) => false,
                );
              }),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(thickness: 1, height: 0),
              ),
              commonListTile(
                ImagePath.icCustomerSupport,
                'Customer Support',
                () {
                  whatsapp();
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(thickness: 1, height: 0),
              ),
              commonListTile(
                ImagePath.icPolicy,
                'Legal Policies',
                () async {
                  // await launchWebUrl(
                  //   'https://greenhouse.org.in/privacy-policy',
                  // );
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    NoAnimationMaterialPageRoute(
                      builder: (context) => LegalPolicies(),
                    ),
                    (route) => false,
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(thickness: 1, height: 0),
              ),
              commonListTile(
                ImagePath.icInfo,
                'About us',
                () async {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    NoAnimationMaterialPageRoute(
                      builder: (context) => AboutUs(),
                    ),
                    (route) => false,
                  );
                },
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(thickness: 1, height: 0)),
              commonListTile(ImagePath.icLogout, 'Logout', () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.remove("token");
                token = "null";

                // ignore: use_build_context_synchronously
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (route) => false,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  whatsapp() async {
    var contact = "+919008627777";
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl =
        "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      print('object');
      // EasyLoading.showError('WhatsApp is not installed.');
    }
  }

  Future launchWebUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  Widget commonListTile(String? imgPath, String? name, onTap) {
    return ListTile(
      horizontalTitleGap: 0,
      leading: Image.asset(
        imgPath!,
        height: 30,
        width: 30,
        color: MyTheme.accent_color,
      ),
      title: Text(
        name!,
        style: const TextStyle(fontSize: 14, color: Colors.black),
      ),
      trailing: const Icon(
        CupertinoIcons.right_chevron,
        color: Colors.grey,
      ),
      onTap: onTap!,
    );
  }
}

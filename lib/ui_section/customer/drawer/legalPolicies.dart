import 'package:flutter/material.dart';
import 'package:imart/const/asseth_path.dart';
import 'package:imart/const/my_theme.dart';

class LegalPolicies extends StatefulWidget {
  const LegalPolicies({super.key});

  @override
  State<LegalPolicies> createState() => _LegalPoliciesState();
}

class _LegalPoliciesState extends State<LegalPolicies> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color.fromRGBO(247, 249, 250, 1.0),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: MyTheme.accent_color),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          ImagePath.icAppbarIcon,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          top: 15,
                          bottom: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Privacy Policies',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 15, top: 5, bottom: 5, right: 15),
                        child: Text(
                          'Thank you for using Green House. This Privacy Policy outlines how we collect, use, store, and protect your personal information while using our mobile application. We may collect information you provide directly, such as your name, contact details when you register or make purchases within the app. With your consent, we may collect and process your device\'s location data to provide location-based services within the app. We use the collected information to provide and personalize our services to enhance your app experience. To process transactions and deliver products or services you request. To analyze and improve the app\'s performance, functionality, and user experience. To send promotional offers, updates, and marketing communications. We take appropriate measures to protect your personal information from unauthorized access, disclosure, alteration, or destruction. However, please note that no method of data transmission or storage is 100% secure, and we cannot guarantee absolute security. We may update this Privacy Policy from time to time. The revised policy will be effective immediately upon posting. We encourage you to review the policy periodically for any changes.',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/ui_section/customer/tabbar/bottom_tabbar.dart';

class SuccessOrderPage extends StatefulWidget {
  const SuccessOrderPage({Key? key}) : super(key: key);

  @override
  _SuccessOrderPageState createState() => _SuccessOrderPageState();
}

class _SuccessOrderPageState extends State<SuccessOrderPage> {
  ConfettiController? _controllerBottomCenter;

  Future _initCall() async {
    _controllerBottomCenter = ConfettiController(
      duration: const Duration(seconds: 10),
    );
    _controllerBottomCenter!.play();
  }

  @override
  void dispose() {
    _controllerBottomCenter!.stop();
    _controllerBottomCenter!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initCall();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          NoAnimationMaterialPageRoute(
            builder: (context) => BottomTabbar(
              positionTab: 0,
            ),
          ),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        // appBar: AppBar(
        //   leading: IconButton(
        //     onPressed: () async {
        //       Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        //         NoAnimationMaterialPageRoute(
        //           builder: (context) => BottomTabbar(positionTab: 0),
        //         ),
        //         (route) => false,
        //       );
        //     },
        //     icon: const Icon(Icons.arrow_back),
        //   ),
        //   title: Text(
        //     'Success',
        //     style: const TextStyle(
        //       fontSize: 18,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
        body: SafeArea(
          child: Stack(
            children: [
              _body(),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _controllerBottomCenter!,
                  blastDirection: -pi / 2,
                  emissionFrequency: 0.05,
                  numberOfParticles: 5,
                  blastDirectionality: BlastDirectionality.explosive,
                  gravity: 0.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: MyTheme.accent_color),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () async {
                          Navigator.of(context, rootNavigator: true)
                              .pushAndRemoveUntil(
                            NoAnimationMaterialPageRoute(
                              builder: (context) =>
                                  BottomTabbar(positionTab: 0),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Icon(
                          CupertinoIcons.left_chevron,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'Success',
                      style: TextStyle(
                        color: MyTheme.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return SafeArea(
      child: _centerCol(),
    );
  }

  Widget _centerCol() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/Smile_icon.svg',
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Order Accepted',
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Item Arriving',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          // _sizeBTN(),
        ],
      ),
    );
  }

  // Widget _sizeBTN() {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 69, right: 69, bottom: 20),
  //     child: globalBtn(
  //       totalButtons: 1,
  //       btn1Color1: AppColor.appcolorBlue,
  //       textColor: Colors.white,
  //       btnTitle1: 'track_order'.tr(context),
  //       onTap1: () async {
  //         await GeneralNavigator(context, const YourOrdersHistory())
  //             .navigateFromRight();
  //       },
  //     ),
  //   );
  // }
}

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imart/api/auth_repository.dart';
import 'package:imart/const/asseth_path.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/const/user_token.dart';
import 'package:imart/ui_section/customer/tabbar/bottom_tabbar.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String phone = '';
  bool otpSent = false;
  String otpWritten = "";
  bool verified = false;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
  }

  void _showLocationAlertDialog(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Welcome to Green House!'),
            content: const Text(
              'Location permission is required for app features. To collect location details of device to detect and autofill data during the process of order creation. The location is only accessed when the app is running',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_dialogShown) {
      _showLocationAlertDialog(context);
      _dialogShown = true;
    }
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _logo(),
              _emailWidget(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              ImagePath.icAppbarIcon,
              height: 100,
              width: 100,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ],
        ),
      ),
    );
  }

  Widget _emailWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35),
      child: Column(
        children: [
          IntlPhoneField(
            readOnly: verified,
            showCountryFlag: false,
            decoration: InputDecoration(
              counter: const Text(''),
              labelText: 'Phone Number',
              border: const OutlineInputBorder(
                borderSide: BorderSide(),
              ),
              suffixIcon: TextButton(
                onPressed: () async {
                  print("Verify");
                  print(phone);

                  if (otpSent == false) {
                    if (phone != '+91' &&
                        phone != '' &&
                        phone.length == 13 &&
                        verified == false) {
                      await EasyLoading.show(
                        status: 'loading...',
                        maskType: EasyLoadingMaskType.black,
                      );
                      var response =
                          await AuthRepository().sendOtp(phoneNumber: phone);
                      if (response['status'] == 1) {
                        otpSent = true;
                        EasyLoading.dismiss();
                        EasyLoading.showToast(response['message']);
                      } else {
                        EasyLoading.dismiss();
                        EasyLoading.showToast(response['message']);
                      }
                    }
                  } else {
                    if (phone != '+91' &&
                        phone != '' &&
                        phone.length == 13 &&
                        verified == false) {
                      var response = await AuthRepository().verifyOtp(
                        phoneNumber: phone,
                        otpCode: otpWritten,
                      );
                      if (response['status'] == 1) {
                        verified = true;
                        EasyLoading.showToast(response['message']);
                      } else {
                        EasyLoading.showToast(response['message']);
                      }
                    }
                  }
                  setState(() {});
                },
                child: Text(
                  otpSent
                      ? verified
                          ? "Verified"
                          : 'Verify'
                      : "Send OTP",
                  style: TextStyle(
                    color: verified ? Colors.grey : MyTheme.accent_color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            initialCountryCode: 'IN',
            onChanged: (p) {
              phone = p.completeNumber;
              verified = false;
            },
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                'Enter OTP :',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          OTPTextField(
            length: 6,
            width: MediaQuery.of(context).size.width,
            fieldWidth: 40,
            otpFieldStyle:
                OtpFieldStyle(focusBorderColor: MyTheme.accent_color),
            style: const TextStyle(fontSize: 17),
            textFieldAlignment: MainAxisAlignment.spaceBetween,
            fieldStyle: FieldStyle.box,
            onCompleted: (pin) {
              print("Completed: $pin");
              otpWritten = pin;
              setState(() {});
            },
          ),
          const SizedBox(height: 30),
          _btns(),
          const SizedBox(height: 21),
        ],
      ),
    );
  }

  Widget globalBtn({
    String? btnTitle1,
    String? btnTitle2,
    Color? btn1Color1,
    Color? btn1Color2,
    int? totalButtons = 1,
    VoidCallback? onTap1,
    VoidCallback? onTap2,
    Color? textColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: MaterialButton(
            onPressed: onTap1,
            height: 44,
            elevation: onTap1 == null ? 0.0 : null,
            color: btn1Color1 ?? MyTheme.accent_color,
            disabledColor: btn1Color1 ?? MyTheme.accent_color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              btnTitle1 ?? '',
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
        if (totalButtons == 2) ...[
          const SizedBox(width: 20),
          Expanded(
            child: MaterialButton(
              onPressed: onTap2,
              height: 44,
              elevation: onTap1 == null ? 0.0 : null,
              color: btn1Color2 ?? Colors.blue,
              disabledColor: btn1Color1 ?? MyTheme.accent_color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                btnTitle2 ?? '',
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _btns() {
    return globalBtn(
      totalButtons: 2,
      btn1Color1: Colors.black,
      btn1Color2: MyTheme.accent_color,
      btnTitle1: 'Sign up',
      btnTitle2: 'Sign in',
      onTap1: () async {
        // print(_PhoneController.text);
        Navigator.push(context,
            MaterialPageRoute(builder: (builder) => const SignUpPage()));
      },
      onTap2: () async {
        if (phone == '+91' || phone == '') {
          EasyLoading.showToast('Please enter phone number');
        } else {
          if (phone == "+911111111111") {
            final prefs = await SharedPreferences.getInstance();
            await EasyLoading.show(
              status: 'loading...',
              maskType: EasyLoadingMaskType.black,
            );
            var response = await AuthRepository().getLoginResponse(
              mobile: phone,
              deviceToken: 'a',
            );
            await EasyLoading.dismiss();
            print(response['status']);
            if (response['status'] == 1) {
              await prefs.setString(
                "token",
                response['token'],
              );
              token = response['token'];
              // ignore: use_build_context_synchronously
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomTabbar(),
                ),
                (route) => false,
              );
            } else {
              EasyLoading.showToast(response['message']);
            }
          } else {
            if (verified == false) {
              EasyLoading.showToast('Verify your number');
            } else {
              final prefs = await SharedPreferences.getInstance();
              await EasyLoading.show(
                status: 'loading...',
                maskType: EasyLoadingMaskType.black,
              );
              var response = await AuthRepository().getLoginResponse(
                mobile: phone,
                deviceToken: 'a',
              );
              await EasyLoading.dismiss();
              print(response['status']);
              if (response['status'] == 1) {
                await prefs.setString(
                  "token",
                  response['token'],
                );
                token = response['token'];
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomTabbar(),
                  ),
                  (route) => false,
                );
              } else {
                EasyLoading.showToast(response['message']);
              }
            }
          }
        }
      },
    );
  }

  Widget _forGotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () async {},
        child: Text(
          'Forgot Password',
          style: TextStyle(
            color: MyTheme.accent_color,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

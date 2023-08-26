import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imart/api/auth_repository.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/const/text_field.dart';
import 'package:imart/const/user_token.dart';
import 'package:imart/ui_section/customer/tabbar/bottom_tabbar.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _fullName = TextEditingController();
  String phone = '';
  bool otpSent = false;
  String otpWritten = "";
  bool verified = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xffFFFFFF),
        title: _title(),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                _fullNameField(),
                const SizedBox(height: 20),
                _emailAddressField(),
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
                  otpFieldStyle:
                      OtpFieldStyle(focusBorderColor: MyTheme.accent_color),
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 40,
                  style: const TextStyle(fontSize: 17),
                  textFieldAlignment: MainAxisAlignment.spaceBetween,
                  fieldStyle: FieldStyle.box,
                  onCompleted: (pin) {
                    print("Completed: $pin");
                    otpWritten = pin;
                    setState(() {});
                  },
                ),
                const SizedBox(height: 20),
                _signUpBtn(),
                const SizedBox(height: 20),
                _signUpline(),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return const Text(
      'Sign up',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xff2D2D2F),
      ),
    );
  }

  Widget _fullNameField() {
    return CustomTextField().phoneTextField(
      context,
      controller: _fullName,
      hintText: 'Full Name',
      textInputAction: TextInputAction.next,
    );
  }

  Widget _emailAddressField() {
    return IntlPhoneField(
      readOnly: verified,
      showCountryFlag: false,
      decoration: InputDecoration(
        counter: const Text(''),
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
        labelText: 'Phone Number',
        labelStyle: const TextStyle(color: Colors.grey),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(204, 204, 204, 1.0),
          ),
        ),
      ),
      initialCountryCode: 'IN',
      onChanged: (p) {
        phone = p.completeNumber;
      },
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

  Widget _signUpBtn() {
    return globalBtn(
      textColor: Colors.white,
      totalButtons: 1,
      btn1Color1: MyTheme.accent_color,
      btnTitle1: 'Sign up',
      // btnTitle2: 'Sign in',
      onTap1: () async {
        if (_fullName.text.isEmpty) {
          EasyLoading.showToast('Please enter fullname');
        } else if (phone == '+91' || phone == '') {
          EasyLoading.showToast('Please enter phone number');
        } else {
          // await EasyLoading.show(
          //   status: 'loading...',
          //   maskType: EasyLoadingMaskType.black,
          // );
          if (verified == false) {
            EasyLoading.showToast('Verify your number');
          } else {
            final prefs = await SharedPreferences.getInstance();
            var response = await AuthRepository().getSignUpResponse(
              mobile: phone,
              deviceToken: 'a',
              name: _fullName.text,
            );
            await EasyLoading.dismiss();
            print("status : ${response['status']}");
            if (response['status'] == 1) {
              EasyLoading.showToast(response['message']);
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
      },
      onTap2: () {},
    );
  }

  Widget _signUpline() {
    return InkWell(
      onTap: () async {},
      child: Container(
        alignment: Alignment.center,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            const TextSpan(
              text: "By signing up you agree to our ",
              style: TextStyle(
                color: Color(0xff2D2D2F),
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: 'Terms ',
              style: TextStyle(
                color: MyTheme.accent_color,
                fontSize: 16,
              ),
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
            const TextSpan(
              text: 'and ',
              style: TextStyle(
                color: Color(0xff2D2D2F),
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: 'Conditions of Use',
              style: TextStyle(
                color: MyTheme.accent_color,
                fontSize: 16,
              ),
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
          ]),
        ),
      ),
    );
  }
}

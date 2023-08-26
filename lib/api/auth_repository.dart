import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imart/const/base_url.dart';

class AuthRepository {
  Future getSignUpResponse(
      {String? mobile, String? deviceToken, String? name}) async {
    var postBody = {
      "mobileno": mobile,
      "device_token": deviceToken,
      "name": name
    };
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.signUp}");
    final response = await http.post(
      url,
      body: jsonEncode(postBody),
      headers: {"Content-Type": "application/json"},
    );
    return jsonDecode(response.body);
  }

  Future getLoginResponse({String? mobile, String? deviceToken}) async {
    var postBody = {
      "mobileno": mobile,
      "device_token": deviceToken,
    };
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.login}");
    final response = await http.post(
      url,
      body: jsonEncode(postBody),
      headers: {"Content-Type": "application/json"},
    );
    return jsonDecode(response.body);
  }

  Future sendOtp({String? phoneNumber}) async {
    var postBody = {
      "phoneNumber": phoneNumber,
    };
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.sendOtp}");
    final response = await http.post(
      url,
      body: jsonEncode(postBody),
      headers: {"Content-Type": "application/json"},
    );
    return jsonDecode(response.body);
  }

  Future verifyOtp({String? phoneNumber, String? otpCode}) async {
    var postBody = {
      "phoneNumber": phoneNumber,
      "otpCode": otpCode,
    };
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.verifyOtp}");
    final response = await http.post(
      url,
      body: jsonEncode(postBody),
      headers: {"Content-Type": "application/json"},
    );
    return jsonDecode(response.body);
  }
}

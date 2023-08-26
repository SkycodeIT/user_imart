import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imart/const/base_url.dart';
import 'package:imart/const/user_token.dart';
import 'package:imart/model/get_address_list_response_model.dart';
import 'package:imart/model/get_order_detail_response_model.dart';

class CheckoutRepository {
  Future setAddress({Map<String, dynamic>? jsonData}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.setAddress}");
    final response = await http.post(
      url,
      body: jsonEncode(jsonData),
      headers: {
        'Authorization': token!,
        "Content-Type": "application/json",
      },
    );
    return json.decode(response.body);
  }

  Future getDefaultAddress(userId) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.getDefaultAddress}");
    var reqBody = {"userId": userId};
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {
        'Authorization': token!,
        "Content-Type": "application/json",
      },
    );
    return GetAddresResponseModel.fromJson(json.decode(response.body));
  }

  Future getAllAddress(userId) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.getAllAddress}");
    var reqBody = {"userId": userId};
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {
        'Authorization': token!,
        "Content-Type": "application/json",
      },
    );
    return GetAddresResponseModel.fromJson(json.decode(response.body));
  }

  Future updateDefaultAdress(id, userId) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.updateDefaultAddress}");
    var reqBody = {
      "id": id,
      "userId": userId,
    };
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {
        'Authorization': token!,
        "Content-Type": "application/json",
      },
    );
    return json.decode(response.body);
  }

  Future getSpecificAddress({String? id}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.specificAddress}");
    var reqBody = {
      "id": id,
    };
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {
        'Authorization': token!,
        "Content-Type": "application/json",
      },
    );
    return AddressDetailResponseModel.fromJson(json.decode(response.body));
  }
}

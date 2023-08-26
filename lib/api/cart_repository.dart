import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imart/const/base_url.dart';
import 'package:imart/const/user_token.dart';
import 'package:imart/model/get_cart_detail_response_model.dart';
import 'package:imart/model/get_cart_list_response_model.dart';
import 'package:imart/model/get_order_items_specific_order.dart';
import 'package:imart/model/get_order_list_response_model.dart';

class CartRepository {
  Future addToCart({String? userId, int? id, int? quantity}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.addToCart}");
    var reqBody = {'userId': userId, 'productId': id, 'quantity': quantity};
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {'Authorization': token!, "Content-Type": "application/json"},
    );
    return json.decode(response.body);
  }

  Future incToCart({String? userId, int? id}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.incToCart}");
    var reqBody = {'userId': userId, 'productId': id};
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {'Authorization': token!, "Content-Type": "application/json"},
    );
    return json.decode(response.body);
  }

  Future decToCart({String? userId, int? id}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.decToCart}");
    var reqBody = {'userId': userId, 'productId': id};
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {'Authorization': token!, "Content-Type": "application/json"},
    );
    return json.decode(response.body);
  }

  Future deleteCart({String? id}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.deleteCart}");
    var reqBody = {'id': id};
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {'Authorization': token!, "Content-Type": 'application/json'},
    );
    return json.decode(response.body);
  }

  Future placeOrder(
      {String? userId,
      String? addid,
      String? name,
      String? total,
      String? payment,
      String? mobile}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.placeorder}");
    var reqBody = {
      "userId": userId,
      "addressId": addid,
      "name": name,
      "subTotal": total,
      "discoutPrice": '0',
      "grandTotal": total,
      "paymentMethod": payment,
      "status": "ordered",
      "mobile": mobile,
      "date": DateTime.now().month < 10
          ? "${DateTime.now().day.toString()}-0${DateTime.now().month.toString()}"
          : "${DateTime.now().day.toString()}-${DateTime.now().month.toString()}",
      "delivereddate": "Still Not Delivered",
    };
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {
        'Authorization': token!,
        "Content-Type": 'application/json',
      },
    );
    return json.decode(response.body);
  }

  Future allUserOrders({String? userId}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.allUserOrders}");
    var reqBody = {"userId": userId};
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {'Authorization': token!, "Content-Type": 'application/json'},
    );
    return GetOrderResponseModel.fromJson(json.decode(response.body));
  }

  Future getCart({String? userId}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.getCartList}");
    var reqBody = {"userId": userId};
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {'Authorization': token!, "Content-Type": 'application/json'},
    );
    return GetCartListResponseModel.fromJson(json.decode(response.body));
  }

  Future checkExistInCart({String? userId, int? productId}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.checkExistInCart}");
    var reqBody = {
      "userId": userId,
      "productId": productId,
    };
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {
        'Authorization': token!,
        "Content-Type": 'application/json',
      },
    );
    return GetCartDetailResponseModel.fromJson(json.decode(response.body));
  }

  Future addOrderItems(
      {String? orderId,
      List<String?>? productName,
      List<int?>? quantity,
      List<String?>? mrpPrice,
      List<String?>? sellPrice,
      List<String?>? kgOrgm,
      List<String?>? image}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.addOrderList}");
    var reqBody = {
      "orderId": orderId,
      "productName": productName,
      "quantity": quantity,
      "mrpPrice": mrpPrice,
      "sellPrice": sellPrice,
      "kgOrgm": kgOrgm,
      "image": image,
    };
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {
        'Authorization': token!,
        "Content-Type": 'application/json',
      },
    );
    return json.decode(response.body);
  }

  Future orderItemsOfSpecificOrder({String? orderId}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.orderListSpecificOrder}");
    var reqBody = {"orderId": orderId};
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {
        'Authorization': token!,
        "Content-Type": 'application/json',
      },
    );
    return GetOrderItemsOfSpecificOrder.fromJson(json.decode(response.body));
  }
}

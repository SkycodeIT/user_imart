import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imart/const/base_url.dart';
import 'package:imart/const/user_token.dart';
import 'package:imart/model/get_category_response_model.dart';
import 'package:imart/model/get_product_by_cat_response_model.dart';
import 'package:imart/model/get_product_detail_response_model.dart';
import 'package:imart/model/get_sub_category_response_model.dart';
import 'package:imart/model/get_wishlist_response_model.dart';

class ProductRepository {
  Future getProductCategory() async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.category}");
    final response = await http.get(
      url,
      headers: {'Authorization': token!},
    );
    return GetCatagoryResponseModel.fromJson(jsonDecode(response.body));
  }

  Future getProductListByCategory({String? id}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.productByCatId}");
    var reqBody = {'categorieId': id};
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {
        'Authorization': token!,
        "Content-Type": "application/json"
      },
    );
    return GetProductbyCatIdResponseModel.fromJson(json.decode(response.body));
  }

  Future getProductListBySubCategory({String? id, String? subId}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.productBySubCatId}");
    var reqBody = {'categorieId': id, 'subCategorieId': subId};
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {
        'Authorization': token!,
        "Content-Type": "application/json"
      },
    );
    return GetProductbyCatIdResponseModel.fromJson(json.decode(response.body));
  }

  Future getAllProductList() async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.products}");
    final response = await http.post(
      url,
      headers: {'Authorization': token!},
    );
    return GetProductbyCatIdResponseModel.fromJson(json.decode(response.body));
  }

  Future getSubCategory({String? id}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.subcategory}");
    var reqbody = {'categorieId': id};
    final response = await http.post(
      url,
      body: jsonEncode(reqbody),
      headers: {
        'Authorization': token!,
        "Content-Type": "application/json"
      },
    );
    return GetSubCategoryResponseModel.fromJson(json.decode(response.body));
  }

  Future getProductDetail({int? id}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.productDetails}");
    var reqBody = {"productId": id};
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {
        'Authorization': token!,
        "Content-Type": "application/json"
      },
    );
    return ProductDetailResponseModel.fromJson(json.decode(response.body));
  }

  Future getWishlist() async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.getWishlist}");
    final response = await http.get(
      url,
      headers: {'Authorization': token!},
    );
    return GetWishlistResponseModel.fromJson(jsonDecode(response.body));
  }

  Future manageWishlist({String? productName, int? wishList}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.addWishlist}");
    var reqBody = {'productName': productName, 'isWishlist': wishList};
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {
        'Authorization': token!,
        "Content-Type": "application/json"
      },
    );
    return json.decode(response.body);
  }
}

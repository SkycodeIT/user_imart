class GetCartListResponseModel {
  int? status;
  String? message;
  List<Data>? data = [];

  GetCartListResponseModel({this.status, this.message, this.data});

  GetCartListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? cartId;
  String? userId;
  int? productId;
  int? quantity;

  Data({this.cartId, this.userId, this.productId, this.quantity});

  Data.fromJson(Map<String, dynamic> json) {
    cartId = json['_id'];
    userId = json['userId'];
    productId = json['productId'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = cartId;
    data['userId'] = userId;
    data['productId'] = productId;
    data['quantity'] = quantity;
    return data;
  }
}

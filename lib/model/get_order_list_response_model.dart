class GetOrderResponseModel {
  int? status;
  String? message;
  List<GetOrderResponseData>? data;

  GetOrderResponseModel({this.status, this.message, this.data});

  GetOrderResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GetOrderResponseData>[];
      json['data'].forEach((v) {
        data!.add(GetOrderResponseData.fromJson(v));
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

class GetOrderResponseData {
  String? id;
  String? userId;
  String? addressId;
  String? name;
  String? subTotal;
  String? discoutPrice;
  String? grandTotal;
  String? paymentMethod;
  String? status;
  String? mobile;
  String? date;
  String? delivereddate;

  GetOrderResponseData(
      {this.id,
      this.userId,
      this.addressId,
      this.name,
      this.subTotal,
      this.discoutPrice,
      this.grandTotal,
      this.paymentMethod,
      this.status,
      this.mobile,
      this.date,
      this.delivereddate});

  GetOrderResponseData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    addressId = json['addressId'];
    name = json['name'];
    subTotal = json['subTotal'];
    discoutPrice = json['discoutPrice'];
    grandTotal = json['grandTotal'];
    paymentMethod = json['paymentMethod'];
    status = json['status'];
    mobile = json['mobile'];
    date = json['date'];
    delivereddate = json['delivereddate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['userId'] = userId;
    data['addressId'] = addressId;
    data['name'] = name;
    data['subTotal'] = subTotal;
    data['discoutPrice'] = discoutPrice;
    data['grandTotal'] = grandTotal;
    data['paymentMethod'] = paymentMethod;
    data['status'] = status;
    data['mobile'] = mobile;
    data['date'] = date;
    data['delivereddate'] = delivereddate;
    return data;
  }
}

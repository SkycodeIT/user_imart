class GetOrderItemsOfSpecificOrder {
  int? status;
  String? message;
  GetOrderItemsOfSpecificOrderData? data;

  GetOrderItemsOfSpecificOrder({this.status, this.message, this.data});

  GetOrderItemsOfSpecificOrder.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? GetOrderItemsOfSpecificOrderData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class GetOrderItemsOfSpecificOrderData {
  String? id;
  String? orderId;
  List<String>? productName;
  List<int>? quantity;
  List<String>? mrpPrice;
  List<String>? sellPrice;
  List<String>? kgOrgm;
  List<String>? image;

  GetOrderItemsOfSpecificOrderData({
    this.id,
    this.orderId,
    this.productName,
    this.quantity,
    this.mrpPrice,
    this.sellPrice,
    this.kgOrgm,
    this.image,
  });

  GetOrderItemsOfSpecificOrderData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    orderId = json['orderId'];
    productName = json['productName'].cast<String>();
    quantity = json['quantity'].cast<int>();
    mrpPrice = json['mrpPrice'].cast<String>();
    sellPrice = json['sellPrice'].cast<String>();
    kgOrgm = json['kgOrgm'].cast<String>();
    image = json['image'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['orderId'] = orderId;
    data['productName'] = productName as List<String>;
    data['quantity'] = quantity as List<int>;
    data['mrpPrice'] = mrpPrice as List<String>;
    data['sellPrice'] = sellPrice as List<String>;
    data['kgOrgm'] = kgOrgm as List<String>;
    data['image'] = image as List<String>;
    return data;
  }
}

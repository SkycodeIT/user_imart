class GetProductbyCatIdResponseModel {
  int? status;
  String? message;
  List<GetProductbyCatIdResponseData>? data;

  GetProductbyCatIdResponseModel({this.status, this.message, this.data});

  GetProductbyCatIdResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GetProductbyCatIdResponseData>[];
      json['data'].forEach((v) {
        data!.add(GetProductbyCatIdResponseData.fromJson(v));
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

class GetProductbyCatIdResponseData {
  int? productId;
  String? categorieId;
  String? subCategorieId;
  String? productName;
  String? description;
  int? unit;
  String? mrpPrice;
  String? sellPrice;
  String? kgOrgm;
  int? isWishlist;
  List<String>? image;

  GetProductbyCatIdResponseData(
      {this.productId,
      this.categorieId,
      this.subCategorieId,
      this.productName,
      this.description,
      this.unit,
      this.mrpPrice,
      this.sellPrice,
      this.kgOrgm,
      this.isWishlist,
      this.image});

  GetProductbyCatIdResponseData.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    categorieId = json['categorieId'];
    subCategorieId = json['subCategorieId'];
    productName = json['productName'];
    description = json['description'];
    unit = json['unit'];
    mrpPrice = json['mrpPrice'];
    kgOrgm = json['kgOrgm'];
    isWishlist = json['isWishlist'];
    sellPrice = json['sellPrice'];
    if (json['image'] != null) {
      image = List<String>.from(
        json['image'].map((dynamic e) => e.toString()),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['categorieId'] = categorieId;
    data['subCategorieId'] = subCategorieId;
    data['productName'] = productName;
    data['description'] = description;
    data['unit'] = unit;
    data['mrpPrice'] = mrpPrice;
    data['sellPrice'] = sellPrice;
    data['kgOrgm'] = kgOrgm;
    data['image'] = image;
    return data;
  }
}

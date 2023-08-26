class ProductDetailResponseModel {
  int? status;
  String? message;
  Data? data;

  ProductDetailResponseModel({this.status, this.message, this.data});

  ProductDetailResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  int? productId;
  String? categorieId;
  String? subCategorieId;
  String? productName;
  String? description;
  int? unit;
  String? mrpPrice;
  String? sellPrice;
  String? kgOrgm;
  String? status;
  Null createdAt;
  Null updatedAt;
  List<String>? image;

  Data(
      {this.productId,
      this.categorieId,
      this.subCategorieId,
      this.productName,
      this.description,
      this.unit,
      this.mrpPrice,
      this.sellPrice,
      this.kgOrgm,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.image});

  Data.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    categorieId = json['categorieId'];
    subCategorieId = json['subCategorieId'];
    productName = json['productName'];
    description = json['description'];
    unit = json['unit'];
    mrpPrice = json['mrpPrice'];
    sellPrice = json['sellPrice'];
    kgOrgm = json['kgOrgm'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['image'] != null) {
      image = List<String>.from(json['image'].map((dynamic e) => e.toString()));
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
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image'] = image as List<String>;
    return data;
  }
}

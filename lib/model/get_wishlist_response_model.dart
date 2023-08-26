class GetWishlistResponseModel {
  int? status;
  String? message;
  List<Data>? data;

  GetWishlistResponseModel({this.status, this.message, this.data});

  GetWishlistResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? id;
  int? productId;
  String? categorieId;
  String? subCategorieId;
  String? productName;
  String? description;
  int? unit;
  String? mrpPrice;
  String? kgOrgm;
  String? sellPrice;
  List<String>? image;

  Data(
      {this.id,
      this.productId,
      this.categorieId,
      this.subCategorieId,
      this.productName,
      this.description,
      this.unit,
      this.mrpPrice,
      this.sellPrice,
      this.kgOrgm,
      this.image});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    productId = json['productId'];
    categorieId = json['categorieId'];
    subCategorieId = json['subCategorieId'];
    productName = json['productName'];
    description = json['description'];
    unit = json['unit'];
    mrpPrice = json['mrpPrice'];
    sellPrice = json['sellPrice'];
    kgOrgm = json['kgOrgm'];
    if (json['image'] != null) {
      image = List<String>.from(json['image'].map((dynamic e) => e.toString()));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
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

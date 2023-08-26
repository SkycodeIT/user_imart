class GetSubCategoryResponseModel {
  int? status;
  String? message;
  List<GetSubCategoryResponseData>? data;

  GetSubCategoryResponseModel({this.status, this.message, this.data});

  GetSubCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GetSubCategoryResponseData>[];
      json['data'].forEach((v) {
        data!.add(GetSubCategoryResponseData.fromJson(v));
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

class GetSubCategoryResponseData {
  String? id;
  String? categorieId;
  String? name;
  String? description;

  GetSubCategoryResponseData(
      {this.id, this.categorieId, this.name, this.description});

  GetSubCategoryResponseData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    categorieId = json['categorieId'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['categorieId'] = categorieId;
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}

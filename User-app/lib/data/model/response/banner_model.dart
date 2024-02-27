import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';

class BannerModel {
  int? id;
  String? photo;
  String? bannerType;
  int? published;
  String? createdAt;
  String? updatedAt;
  String? url;
  String? resourceType;
  int? resourceId;
  Product? product;

  BannerModel(
      {this.id,
        this.photo,
        this.bannerType,
        this.published,
        this.createdAt,
        this.updatedAt,
        this.url,
        this.resourceType,
        this.resourceId,
        this.product
      });

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photo = json['photo'];
    bannerType = json['banner_type'];
    published = json['published'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    url = json['url'];
    resourceType = json['resource_type'];
    resourceId = json['resource_id'];
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['photo'] = photo;
    data['banner_type'] = bannerType;
    data['published'] = published;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['url'] = url;
    data['resource_type'] = resourceType;
    data['resource_id'] = resourceId;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

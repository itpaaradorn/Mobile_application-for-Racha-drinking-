class BrandWaterModel {
  String? brandId;
  String? brandName;
  String? brandImage;
  String? idShop;

  BrandWaterModel({this.brandId, this.brandName, this.brandImage, this.idShop});

  BrandWaterModel.fromJson(Map<String, dynamic> json) {
    brandId = json['brand_id'];
    brandName = json['brand_name'];
    brandImage = json['brand_image'];
    idShop = json['idShop'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brand_id'] = this.brandId;
    data['brand_name'] = this.brandName;
    data['brand_image'] = this.brandImage;
    data['idShop'] = this.idShop;
    return data;
  }
}

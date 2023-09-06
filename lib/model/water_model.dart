class WaterModel {
  String? id;
  String? pathImage;
  String? price;
  String? size;
  String? idbrand;
  String? quantity;
  String? brandName;

  WaterModel(
      {this.id,
      this.pathImage,
      this.price,
      this.size,
      this.idbrand,
      this.quantity,
      this.brandName});

  WaterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pathImage = json['PathImage'];
    price = json['Price'];
    size = json['Size'];
    idbrand = json['idbrand'];
    quantity = json['quantity'];
    brandName = json['brand_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['PathImage'] = this.pathImage;
    data['Price'] = this.price;
    data['Size'] = this.size;
    data['idbrand'] = this.idbrand;
    data['quantity'] = this.quantity;
    data['brand_name'] = this.brandName;
    return data;
  }
}

class WaterModel {
  String? id;
  String? idShop;
  String? brandname;
  String? pathImage;
  String? price;
  String? size;
  String? idbrand;
  String? quantity;

  WaterModel(
      {this.id,
      this.idShop,
      this.brandname,
      this.pathImage,
      this.price,
      this.size,
      this.idbrand,
      this.quantity});

  WaterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idShop = json['idShop'];
    brandname = json['brandname'];
    pathImage = json['PathImage'];
    price = json['Price'];
    size = json['Size'];
    idbrand = json['idbrand'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idShop'] = this.idShop;
    data['brandname'] = this.brandname;
    data['PathImage'] = this.pathImage;
    data['Price'] = this.price;
    data['Size'] = this.size;
    data['idbrand'] = this.idbrand;
    data['quantity'] = this.quantity;
    return data;
  }
}

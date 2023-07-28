class WaterModel {
  String? id;
  String? idShop;
  String? nameWater;
  String? pathImage;
  String? price;
  String? size;
  String? idbrand;

  WaterModel(
      {this.id,
      this.idShop,
      this.nameWater,
      this.pathImage,
      this.price,
      this.size,
      this.idbrand});

  WaterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idShop = json['idShop'];
    nameWater = json['NameWater'];
    pathImage = json['PathImage'];
    price = json['Price'];
    size = json['Size'];
    idbrand = json['idbrand'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idShop'] = this.idShop;
    data['NameWater'] = this.nameWater;
    data['PathImage'] = this.pathImage;
    data['Price'] = this.price;
    data['Size'] = this.size;
    data['idbrand'] = this.idbrand;
    return data;
  }

  void add(WaterModel waterModel) {}
}

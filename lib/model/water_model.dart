class WaterModel {
  String? id;
  String? idShop;
  String? nameWater;
  String? pathImage;
  String? price;
  String? size;

  WaterModel(
      {this.id,
      this.idShop,
      this.nameWater,
      this.pathImage,
      this.price,
      this.size});

  WaterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idShop = json['idShop'];
    nameWater = json['NameWater'];
    pathImage = json['PathImage'];
    price = json['Price'];
    size = json['Size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idShop'] = this.idShop;
    data['NameWater'] = this.nameWater;
    data['PathImage'] = this.pathImage;
    data['Price'] = this.price;
    data['Detail'] = this.size;
    return data;
  }

  static void add(WaterModel model) {}
}

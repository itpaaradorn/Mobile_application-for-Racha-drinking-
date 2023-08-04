class CartModel {
  int? id;
  String? waterId;
  String? brandId;
  String? brandName;
  String? price;
  String? size;
  String? amount;
  String? sum;
  String? distance;
  String? transport;

  CartModel(
      {this.id,
      this.waterId,
      this.brandId,
      this.brandName,
      this.price,
      this.size,
      this.amount,
      this.sum,
      this.distance,
      this.transport});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    waterId = json['water_id'];
    brandId = json['brand_id'];
    brandName = json['brand_name'];
    price = json['price'];
    size = json['size'];
    amount = json['amount'];
    sum = json['sum'];
    distance = json['distance'];
    transport = json['transport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['water_id'] = this.waterId;
    data['brand_id'] = this.brandId;
    data['brand_name'] = this.brandName;
    data['price'] = this.price;
    data['size'] = this.size;
    data['amount'] = this.amount;
    data['sum'] = this.sum;
    data['distance'] = this.distance;
    data['transport'] = this.transport;
    return data;
  }
}

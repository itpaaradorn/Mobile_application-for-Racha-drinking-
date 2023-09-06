class OrderDetail {
  String? id;
  String? waterId;
  String? amount;
  String? sum;
  String? distance;
  String? transport;
  String? createBy;
  String? status;
  String? price;
  String? size;
  String? idbrand;
  String? quantity;
  String? brandName;

  OrderDetail(
      {this.id,
      this.waterId,
      this.amount,
      this.sum,
      this.distance,
      this.transport,
      this.createBy,
      this.status,
      this.price,
      this.size,
      this.idbrand,
      this.quantity,
      this.brandName});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    waterId = json['water_id'];
    amount = json['amount'];
    sum = json['sum'];
    distance = json['distance'];
    transport = json['transport'];
    createBy = json['create_by'];
    status = json['status'];
    price = json['Price'];
    size = json['Size'];
    idbrand = json['idbrand'];
    quantity = json['quantity'];
    brandName = json['brand_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['water_id'] = this.waterId;
    data['amount'] = this.amount;
    data['sum'] = this.sum;
    data['distance'] = this.distance;
    data['transport'] = this.transport;
    data['create_by'] = this.createBy;
    data['status'] = this.status;
    data['Price'] = this.price;
    data['Size'] = this.size;
    data['idbrand'] = this.idbrand;
    data['quantity'] = this.quantity;
    data['brand_name'] = this.brandName;
    return data;
  }
}

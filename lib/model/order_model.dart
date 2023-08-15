class OrderModel {
  String? orderId;
  String? orderDateTime;
  String? userId;
  String? userName;
  String? waterId;
  String? waterBrandId;
  String? size;
  String? distance;
  String? transport;
  String? waterBrandName;
  String? price;
  String? amount;
  String? sum;
  String? riderId;
  String? pamentStatus;
  String? status;

  OrderModel(
      {this.orderId,
      this.orderDateTime,
      this.userId,
      this.userName,
      this.waterId,
      this.waterBrandId,
      this.size,
      this.distance,
      this.transport,
      this.waterBrandName,
      this.price,
      this.amount,
      this.sum,
      this.riderId,
      this.pamentStatus,
      this.status});

  OrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderDateTime = json['orderDateTime'];
    userId = json['user_id'];
    userName = json['user_name'];
    waterId = json['water_id'];
    waterBrandId = json['water_brand_id'];
    size = json['size'];
    distance = json['distance'];
    transport = json['transport'];
    waterBrandName = json['water_brand_name'];
    price = json['price'];
    amount = json['amount'];
    sum = json['sum'];
    riderId = json['riderId'];
    pamentStatus = json['pamentStatus'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['orderDateTime'] = this.orderDateTime;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['water_id'] = this.waterId;
    data['water_brand_id'] = this.waterBrandId;
    data['size'] = this.size;
    data['distance'] = this.distance;
    data['transport'] = this.transport;
    data['water_brand_name'] = this.waterBrandName;
    data['price'] = this.price;
    data['amount'] = this.amount;
    data['sum'] = this.sum;
    data['riderId'] = this.riderId;
    data['pamentStatus'] = this.pamentStatus;
    data['status'] = this.status;
    return data;
  }
}

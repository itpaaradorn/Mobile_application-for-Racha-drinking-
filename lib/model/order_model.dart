class OrderModel {
  String? orderTableId;
  String? paymentStatus;
  String? orderNumber;
  String? createAt;
  String? amount;
  String? sum;
  String? distance;
  String? transport;
  String? price;
  String? size;
  String? brandName;
  String? name;
  String? userId;
  String? riderName;
  String? status;
  String? brandId;
  String? waterId;
  String? riderId;
  String? userPhone;

  OrderModel({
    this.orderTableId,
    this.paymentStatus,
    this.orderNumber,
    this.createAt,
    this.amount,
    this.sum,
    this.distance,
    this.transport,
    this.price,
    this.size,
    this.brandName,
    this.name,
    this.userId,
    this.riderName,
    this.status,
    this.brandId,
    this.waterId,
    this.riderId,
    this.userPhone,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    orderTableId = json['order_table_id'];
    paymentStatus = json['payment_status'];
    orderNumber = json['order_number'];
    createAt = json['create_at'];
    amount = json['amount'];
    sum = json['sum'];
    distance = json['distance'];
    transport = json['transport'];
    price = json['Price'];
    size = json['Size'];
    brandName = json['brand_name'];
    name = json['Name'];
    userId = json['user_id'];
    riderName = json['rider_name'];
    status = json['status'];
    brandId = json['brand_id'];
    waterId = json['water_id'];
    riderId = json['rider_id'];
    userPhone = json['user_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_table_id'] = this.orderTableId;
    data['payment_status'] = this.paymentStatus;
    data['order_number'] = this.orderNumber;
    data['create_at'] = this.createAt;
    data['amount'] = this.amount;
    data['sum'] = this.sum;
    data['distance'] = this.distance;
    data['transport'] = this.transport;
    data['Price'] = this.price;
    data['Size'] = this.size;
    data['brand_name'] = this.brandName;
    data['Name'] = this.name;
    data['user_id'] = this.userId;
    data['rider_name'] = this.riderName;
    data['status'] = this.status;
    data['brand_id'] = this.brandId;
    data['water_id'] = this.waterId;
    data['rider_id'] = this.riderId;
    data['user_phone'] = this.userPhone;
    return data;
  }
}

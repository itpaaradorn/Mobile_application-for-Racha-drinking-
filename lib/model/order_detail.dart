class OrderDetail {
  String? id;
  String? createBy;
  String? empId;
  String? waterId;
  String? amount;
  String? sum;
  String? distance;
  String? transport;
  String? price;
  String? size;
  String? idbrand;
  String? quantity;
  String? brandName;
  String? paymentStatus;

  OrderDetail(
      {this.id,
      this.createBy,
      this.empId,
      this.waterId,
      this.amount,
      this.sum,
      this.distance,
      this.transport,
      this.price,
      this.size,
      this.idbrand,
      this.quantity,
      this.brandName,
      this.paymentStatus});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createBy = json['create_by'];
    empId = json['emp_id'];
    waterId = json['water_id'];
    amount = json['amount'];
    sum = json['sum'];
    distance = json['distance'];
    transport = json['transport'];
    price = json['Price'];
    size = json['Size'];
    idbrand = json['idbrand'];
    quantity = json['quantity'];
    brandName = json['brand_name'];
    paymentStatus = json['payment_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['create_by'] = this.createBy;
    data['emp_id'] = this.empId;
    data['water_id'] = this.waterId;
    data['amount'] = this.amount;
    data['sum'] = this.sum;
    data['distance'] = this.distance;
    data['transport'] = this.transport;
    data['Price'] = this.price;
    data['Size'] = this.size;
    data['idbrand'] = this.idbrand;
    data['quantity'] = this.quantity;
    data['brand_name'] = this.brandName;
    data['payment_status'] = this.paymentStatus;
    return data;
  }
}

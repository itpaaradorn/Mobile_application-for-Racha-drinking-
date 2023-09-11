class OrderModel {
  String? id;
  String? createAt;
  String? createBy;
  String? empId;
  String? paymentStatus;
  String? status;
  String? waterId;
  String? amount;
  String? sum;
  String? distance;
  String? transport;
  String? price;
  String? size;
  String? idbrand;
  String? brandName;

  OrderModel(
      {this.id,
      this.createAt,
      this.createBy,
      this.empId,
      this.paymentStatus,
      this.status,
      this.waterId,
      this.amount,
      this.sum,
      this.distance,
      this.transport,
      this.price,
      this.size,
      this.idbrand,
      this.brandName});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createAt = json['create_at'];
    createBy = json['create_by'];
    empId = json['emp_id'];
    paymentStatus = json['payment_status'];
    status = json['status'];
    waterId = json['water_id'];
    amount = json['amount'];
    sum = json['sum'];
    distance = json['distance'];
    transport = json['transport'];
    price = json['Price'];
    size = json['Size'];
    idbrand = json['idbrand'];
    brandName = json['brand_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['create_at'] = this.createAt;
    data['create_by'] = this.createBy;
    data['emp_id'] = this.empId;
    data['payment_status'] = this.paymentStatus;
    data['status'] = this.status;
    data['water_id'] = this.waterId;
    data['amount'] = this.amount;
    data['sum'] = this.sum;
    data['distance'] = this.distance;
    data['transport'] = this.transport;
    data['Price'] = this.price;
    data['Size'] = this.size;
    data['idbrand'] = this.idbrand;
    data['brand_name'] = this.brandName;
    return data;
  }
}

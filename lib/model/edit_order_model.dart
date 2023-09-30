class EditOrderModel {
  String? id;
  String? pathImage;
  String? price;
  String? size;
  String? quantity;
  String? brandName;
  String? orderTableDetail;
  String? orderDetailIdOld;
  String? orderNumber;
  String? orderDetailId;
  String? amount;
  String? distance;
  String? transport;
  String? paymentStatus;
  String? createBy;
  String? status;

  EditOrderModel(
      {this.id,
      this.pathImage,
      this.price,
      this.size,
      this.quantity,
      this.brandName,
      this.orderTableDetail,
      this.orderDetailIdOld,
      this.orderNumber,
      this.orderDetailId,
      this.amount,
      this.distance,
      this.transport,
      this.paymentStatus,
      this.createBy, this.status});

  EditOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pathImage = json['PathImage'];
    price = json['Price'];
    size = json['Size'];
    quantity = json['quantity'];
    brandName = json['brand_name'];
    orderTableDetail = json['order_table_detail'];
    orderDetailIdOld = json['order_detail_id_old'];
    orderNumber = json['order_number'];
    orderDetailId = json['order_detail_id'];
    amount = json['amount'];
    distance = json['distance'];
    transport = json['transport'];
    paymentStatus = json['payment_status'];
    createBy = json['create_by'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['PathImage'] = this.pathImage;
    data['Price'] = this.price;
    data['Size'] = this.size;
    data['quantity'] = this.quantity;
    data['brand_name'] = this.brandName;
    data['order_table_detail'] = this.orderTableDetail;
    data['order_detail_id_old'] = this.orderDetailIdOld;
    data['order_number'] = this.orderNumber;
    data['order_detail_id'] = this.orderDetailId;
    data['amount'] = this.amount;
    data['distance'] = this.distance;
    data['transport'] = this.transport;
    data['payment_status'] = this.paymentStatus;
    data['create_by'] = this.createBy;
    data['status'] = this.status;
    return data;
  }
}

class PaymentModels {
  String? payId;
  String? slipDateTime;
  String? imageSlip;
  String? orderId;
  String? userId;
  String? userName;
  String? total;
  String? empId;

  PaymentModels(
      {this.payId,
      this.slipDateTime,
      this.imageSlip,
      this.orderId,
      this.userId,
      this.userName,
      this.total,
      this.empId});

  PaymentModels.fromJson(Map<String, dynamic> json) {
    payId = json['pay_id'];
    slipDateTime = json['slip_date_time'];
    imageSlip = json['image_slip'];
    orderId = json['order_id'];
    userId = json['user_id'];
    userName = json['user_name'];
    total = json['total'];
    empId = json['emp_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pay_id'] = this.payId;
    data['slip_date_time'] = this.slipDateTime;
    data['image_slip'] = this.imageSlip;
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['total'] = this.total;
    data['emp_id'] = this.empId;
    return data;
  }
}

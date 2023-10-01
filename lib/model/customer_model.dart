class CustomerModel {
  String? id;
  String? chooseType;
  String? name;
  String? user;
  String? password;
  String? address;
  String? phone;
  String? urlPicture;
  String? lat;
  String? lng;
  String? token;

  CustomerModel(
      {this.id,
      this.chooseType,
      this.name,
      this.user,
      this.password,
      this.address,
      this.phone,
      this.urlPicture,
      this.lat,
      this.lng,
      this.token});

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chooseType = json['ChooseType'];
    name = json['Name'];
    user = json['User'];
    password = json['Password'];
    address = json['Address'];
    phone = json['Phone'];
    urlPicture = json['UrlPicture'];
    lat = json['Lat'];
    lng = json['Lng'];
    token = json['Token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ChooseType'] = this.chooseType;
    data['Name'] = this.name;
    data['User'] = this.user;
    data['Password'] = this.password;
    data['Address'] = this.address;
    data['Phone'] = this.phone;
    data['UrlPicture'] = this.urlPicture;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    data['Token'] = this.token;
    return data;
  }
}

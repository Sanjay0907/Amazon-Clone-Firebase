import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AddressModel {
  String? name;
  String? mobileNumber;
  String? authenticatedMobileNumber; // do not add textfield for this param
  String? houseNumber;
  String? area;
  String? landMark;
  String? pincode;
  String? town;
  String? state;
  String? docID;
  bool? isDefault;
  AddressModel({
    this.name,
    this.mobileNumber,
    this.authenticatedMobileNumber,
    this.houseNumber,
    this.area,
    this.landMark,
    this.pincode,
    this.town,
    this.state,
    this.docID,
    this.isDefault,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'mobileNumber': mobileNumber,
      'authenticatedMobileNumber': authenticatedMobileNumber,
      'houseNumber': houseNumber,
      'area': area,
      'landMark': landMark,
      'pincode': pincode,
      'town': town,
      'state': state,
      'docID': docID,
      'isDefault': isDefault,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      name: map['name'] != null ? map['name'] as String : null,
      mobileNumber: map['mobileNumber'] != null ? map['mobileNumber'] as String : null,
      authenticatedMobileNumber: map['authenticatedMobileNumber'] != null ? map['authenticatedMobileNumber'] as String : null,
      houseNumber: map['houseNumber'] != null ? map['houseNumber'] as String : null,
      area: map['area'] != null ? map['area'] as String : null,
      landMark: map['landMark'] != null ? map['landMark'] as String : null,
      pincode: map['pincode'] != null ? map['pincode'] as String : null,
      town: map['town'] != null ? map['town'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      docID: map['docID'] != null ? map['docID'] as String : null,
      isDefault: map['isDefault'] != null ? map['isDefault'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

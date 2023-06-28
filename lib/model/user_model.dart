import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String? name;
  final String? mobileNum;
  final String? userType;
  UserModel({
    this.name,
    this.mobileNum,
    this.userType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'mobileNum': mobileNum,
      'userType': userType,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] != null ? map['name'] as String : null,
      mobileNum: map['mobileNum'] != null ? map['mobileNum'] as String : null,
      userType: map['userType'] != null ? map['userType'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

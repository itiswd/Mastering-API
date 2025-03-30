import 'package:mastering_flutter_api/core/api/end_points.dart';

class UserModel {
  final String profilePic;
  final String email;
  final String name;
  final String phone;
  final Map<String, dynamic> location;

  UserModel({
    required this.profilePic,
    required this.email,
    required this.name,
    required this.phone,
    required this.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      profilePic: json[ApiKeys.profilePic],
      email: json[ApiKeys.email],
      name: json[ApiKeys.name],
      phone: json[ApiKeys.phone],
      location: json[ApiKeys.location],
    );
  }
}

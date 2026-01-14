import 'package:provider_clearn_architecture/features/profile/domain/entities/user.dart';

class UserModel extends User{
  
  UserModel({required super.id, required super.firstname, required super.lastname, required super.gender});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      gender: json['gender']
    );
  }
  
}
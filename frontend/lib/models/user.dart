import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  int? id;
  String first_name;
  String last_name;
  String email;
  String? password;
  User(
      {this.id,
      required this.first_name,
      required this.last_name,
      required this.email,
      this.password});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

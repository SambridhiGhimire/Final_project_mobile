import '../dto/login_dto.dart';

class EditProfileResponse {
  EditProfileResponse({required this.message, required this.user});

  final String message;
  final User user;

  factory EditProfileResponse.fromJson(Map<String, dynamic> json) => EditProfileResponse(message: json["message"], user: User.fromJson(json["user"]));

  Map<String, dynamic> toJson() => {"message": message, "user": user.toJson()};
}

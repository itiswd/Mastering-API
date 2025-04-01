import 'package:mastering_flutter_api/models/user_model.dart';

class UserState {}

final class UserInitial extends UserState {}

final class SignUpLoading extends UserState {}

final class SignUpSuccess extends UserState {
  final String message;
  SignUpSuccess({required this.message});
}

final class SignUpError extends UserState {
  final String errorMessage;
  SignUpError({required this.errorMessage});
}

final class SignInLoading extends UserState {}

final class SignInSuccess extends UserState {}

final class SignInError extends UserState {
  final String errorMessage;
  SignInError({required this.errorMessage});
}

final class UserProfileLoading extends UserState {}

final class UserProfileSuccess extends UserState {
  final UserModel userModel;
  UserProfileSuccess({required this.userModel});
}

final class UserProfileError extends UserState {
  final String errorMessage;
  UserProfileError({required this.errorMessage});
}

final class UploadProfilePic extends UserState {}

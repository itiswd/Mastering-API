class UserState {}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserSuccess extends UserState {}

final class UserError extends UserState {
  final String message;
  UserError(this.message);
}

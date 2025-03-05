part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;

  ProfileLoaded({required this.user});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}

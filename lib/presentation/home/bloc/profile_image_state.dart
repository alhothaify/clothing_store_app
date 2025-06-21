import 'package:ecommerce/domain/auth/entity/user.dart';

// Define the Profile Image States
abstract class ProfileImageState {}

class ProfileImageLoading extends ProfileImageState {}

class ProfileImageLoaded extends ProfileImageState {
  final UserEntity user;
  ProfileImageLoaded({required this.user});
}

class ProfileImageFailure extends ProfileImageState {}


class ProfileImageUploaded extends ProfileImageState {}

class ProfileImageEdited extends ProfileImageState {}

class ProfileImageDeleted extends ProfileImageState {}

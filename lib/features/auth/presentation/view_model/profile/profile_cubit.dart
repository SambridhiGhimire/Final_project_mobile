import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wastemanagement/features/auth/data/dto/login_dto.dart';

import '../../../domain/use_case/fetch_user_profile.dart';
import '../../../domain/use_case/update_profile.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final FetchUserProfile fetchUserProfile;
  final UpdateProfile updateProfile;
  ProfileCubit(this.fetchUserProfile, this.updateProfile) : super(ProfileLoading());

  void getUserProfile() async {
    final res = await fetchUserProfile();
    res.fold((l) => emit(ProfileError(message: l.message)), (r) => emit(ProfileLoaded(user: r)));
  }

  void updateUserProfile(String name, File? image) async {
    emit(ProfileLoading());
    final res = await updateProfile(UpdateProfileParams(name: name, image: image));
    res.fold((l) => emit(ProfileError(message: l.message)), (r) => emit(ProfileLoaded(user: r)));
  }
}

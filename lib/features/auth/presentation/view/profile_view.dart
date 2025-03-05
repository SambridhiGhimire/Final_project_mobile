import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wastemanagement/app/constants/api_endpoints.dart';
import 'package:wastemanagement/app/constants/theme_constant.dart';
import 'package:wastemanagement/features/auth/presentation/view_model/profile/profile_cubit.dart';
import 'package:wastemanagement/features/home/presentation/view/bottom_view_model/dashboard_bloc.dart';

import '../../../../core/common/permission_checker/permission_checker.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) return const Center(child: CircularProgressIndicator());

        if (state is ProfileError) return Center(child: Text(state.message));

        if (state is ProfileLoaded) {
          return Container(
            color: const Color(0xFFE0EEE0),
            child: Column(
              children: [
                // Profile Section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: double.maxFinite, height: 40),
                      Container(
                        clipBehavior: Clip.hardEdge,
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF2E8B57).withOpacity(0.2)),
                        child: Center(
                          child:
                              state.user.profileImage != null
                                  ? Image.network('${ApiEndpoints.url}${state.user.profileImage}', width: 100, height: 100, fit: BoxFit.cover)
                                  : Text(
                                    state.user.name.substring(0, 1),
                                    style: const TextStyle(fontSize: 40, color: Color(0xFF2E8B57), fontWeight: FontWeight.bold),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Name
                      Text(state.user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2E8B57))),
                      const SizedBox(height: 2),
                      Text(state.user.email, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ThemeConstant.appBarColor)),
                      const SizedBox(height: 32),

                      // Points Container
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: const Color(0xFF2E8B57).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          '${context.read<DashboardBloc>().points} Points',
                          style: const TextStyle(fontSize: 16, color: Color(0xFF2E8B57), fontWeight: FontWeight.w500),
                        ),
                      ),

                      const SizedBox(height: 32),

                      ElevatedButton(
                        onPressed: () => _showEditDialog(context, state),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E8B57)),
                        child: const Text('Edit Profile'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

void _showEditDialog(BuildContext context, ProfileLoaded state) {
  final TextEditingController nameController = TextEditingController(text: state.user.name);
  XFile? newImage;

  final cubit = context.read<ProfileCubit>();

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return BlocProvider.value(
        value: cubit,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            bool isNameValid = nameController.text.trim().isNotEmpty;

            return AlertDialog(
              insetPadding: const EdgeInsets.all(16),
              backgroundColor: ThemeConstant.background,
              title: const Text('Edit Profile'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Colors.grey[300],
                              title: const Text("Select Image Source"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      await PermissionChecker.checkCameraPermission();
                                      final photo = await ImagePicker().pickImage(source: ImageSource.camera);
                                      if (photo != null) setState(() => newImage = photo);
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.camera, color: Colors.white),
                                    label: const Text('Camera'),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      await PermissionChecker.checkCameraPermission();
                                      final photo = await ImagePicker().pickImage(source: ImageSource.gallery);
                                      if (photo != null) setState(() => newImage = photo);
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.image, color: Colors.white),
                                    label: const Text('Gallery'),
                                  ),
                                ],
                              ),
                            ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          newImage != null
                              ? FileImage(File(newImage!.path))
                              : (state.user.profileImage != null ? NetworkImage('${ApiEndpoints.url}${state.user.profileImage}') : null)
                                  as ImageProvider?,
                      child: (newImage == null && state.user.profileImage == null) ? const Icon(Icons.camera_alt) : null,
                    ),
                  ),
                  SizedBox(height: 16, width: double.maxFinite),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    onChanged: (value) {
                      setState(() {
                        isNameValid = value.trim().isNotEmpty;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed:
                      isNameValid
                          ? () {
                            context.read<ProfileCubit>().updateUserProfile(
                              nameController.text.trim(),
                              newImage != null ? File(newImage!.path) : null,
                            );
                            Navigator.pop(context);
                          }
                          : null,
                  child: const Text('Save'),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

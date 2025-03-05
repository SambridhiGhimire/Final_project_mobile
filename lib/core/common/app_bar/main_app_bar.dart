import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/home/presentation/view_model/home_cubit.dart';
import '../logo.dart';
import '../snackbar/snackbar.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isDarkTheme;

  const MainAppBar({super.key, required this.isDarkTheme});

  @override
  _MainAppBarState createState() => _MainAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    final Color logoutIconColor = Colors.red;

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          SizedBox(height: 50, child: Logo(height: 40.0)),
          SizedBox(width: 16),
          Text('Waste Management', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
        ],
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        IconButton(
          icon: Icon(Icons.logout, color: logoutIconColor),
          onPressed: () {
            showMySnackBar(context: context, message: 'Logging out...', color: Colors.black54);
            context.read<HomeCubit>().logout(context);
          },
        ),
      ],
    );
  }
}

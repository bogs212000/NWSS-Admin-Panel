// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwss_admin/constants/controllers.dart';
import 'package:nwss_admin/constants/style.dart';
import 'package:nwss_admin/helpers/reponsiveness.dart';
import 'package:nwss_admin/routing/routes.dart';
import 'package:nwss_admin/widgets/custom_text.dart';
import 'package:nwss_admin/widgets/side_menu_item.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(color: Colors.white
      ),
      child: ListView(
        children: [
          Divider(
            color: dark,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: sideMenuItemRoutes
                .map((item) => SideMenuItem(
              itemName: item.name,
              onTap: () {
                if (item.route == authenticationPageRoute) {
                  _logOut(context); // Show the dialog on logout item click
                } else {
                  if (!menuController.isActive(item.name)) {
                    menuController.changeActiveItemTo(item.name);
                    if (ResponsiveWidget.isSmallScreen(context)) {
                      Get.back();
                    }
                    navigationController.navigateTo(item.route);
                  }
                }
              },
            ))
                .toList(),
          )
        ],
      ),
    );
  }

  void _logOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
              fbAuth.signOut();
                Get.back();
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}

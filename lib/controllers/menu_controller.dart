import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwss_admin/constants/style.dart';
import 'package:nwss_admin/routing/routes.dart';

class MenuController extends GetxController {
  static MenuController instance = Get.find();
  var activeItem = overviewPageDisplayName.obs;

  var hoverItem = "".obs;

  changeActiveItemTo(String itemName) {
    activeItem.value = itemName;
  }

  onHover(String itemName) {
    if (!isActive(itemName)) hoverItem.value = itemName;
  }

  isHovering(String itemName) => hoverItem.value == itemName;

  isActive(String itemName) => activeItem.value == itemName;

  Widget returnIconFor(String itemName) {
    switch (itemName) {
      case overviewPageDisplayName:
        return _customIcon(Icons.trending_up, itemName);
      case driversPageDisplayName:
        return _customIcon(Icons.admin_panel_settings_outlined, itemName);
      case clientsPageDisplayName:
        return _customIcon(Icons.people_alt_outlined, itemName);
      case notificationsPageDisplayName:
        return _customIcon(Icons.notifications_active_outlined, itemName);
      case transactionsPageDisplayName:
        return _customIcon(Icons.list_alt_outlined, itemName);
      case chatPageDisplayName:
        return _customIcon(Icons.chat_outlined, itemName);
      case controlPageDisplayName:
        return _customIcon(Icons.keyboard_command_key, itemName);
      default:
        return _customIcon(Icons.exit_to_app, itemName);
    }
  }

  Widget _customIcon(IconData icon, String itemName) {
    if (isActive(itemName)) return Icon(icon, size: 30, color: dark);

    return Icon(
      icon,
      color: isHovering(itemName) ? dark : dark,
    );
  }
}

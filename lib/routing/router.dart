import 'package:flutter/material.dart';
import 'package:nwss_admin/pages/clients/clients.dart';
import 'package:nwss_admin/pages/control/control.page.dart';
import 'package:nwss_admin/pages/drivers/drivers.dart';
import 'package:nwss_admin/pages/notifications/notifications.dart';
import 'package:nwss_admin/pages/overview/overview.dart';
import 'package:nwss_admin/pages/transactions/transactions.dart';
import 'package:nwss_admin/routing/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case overviewPageRoute:
      return _getPageRoute(OverviewPage());
    case driversPageRoute:
      return _getPageRoute(const DriversPage());
    case clientsPageRoute:
      return _getPageRoute(const ClientsPage());
    case notificationsPageRoute:
      return _getPageRoute(NotificationsPage());
    case transactionsPageRoute:
      return _getPageRoute(TransactionPage());
    default:
      return _getPageRoute(const ControlPage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

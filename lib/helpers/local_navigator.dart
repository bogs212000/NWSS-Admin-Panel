import 'package:flutter/cupertino.dart';
import 'package:nwss_admin/constants/controllers.dart';
import 'package:nwss_admin/routing/router.dart';
import 'package:nwss_admin/routing/routes.dart';

Navigator localNavigator() => Navigator(
      key: navigationController.navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: overviewPageRoute,
    );

// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwss_admin/constants/controllers.dart';
import 'package:nwss_admin/helpers/reponsiveness.dart';
import 'package:nwss_admin/pages/overview/widgets/available_drivers_table.dart';
import 'package:nwss_admin/pages/overview/widgets/overview_cards_large.dart';
import 'package:nwss_admin/pages/overview/widgets/overview_cards_medium.dart';
import 'package:nwss_admin/pages/overview/widgets/overview_cards_small.dart';
import 'package:nwss_admin/pages/overview/widgets/revenue_section_large.dart';
import 'package:nwss_admin/widgets/custom_text.dart';

import '../../functions/fetch.dart';
import 'widgets/revenue_section_small.dart';

class OverviewPage extends StatefulWidget {
  OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  @override
  void initState() {
    super.initState();
    fetchRelease(setState);
    fetchMaintenance(setState);
    fetchControl(setState);
    fetchTermsConditions(setState);
    fetchGuide(setState);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Row(
            children: [
              Container(
                  margin: EdgeInsets.only(top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6),
                  child: CustomText(
                    text: menuController.activeItem.value,
                    size: 24,
                    weight: FontWeight.bold,
                  )),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              // if (ResponsiveWidget.isLargeScreen(context) || ResponsiveWidget.isMediumScreen(context))
              //   if (ResponsiveWidget.isCustomSize(context)) const OverviewCardsMediumScreen() else const OverviewCardsLargeScreen()
              // else
              //   const OverviewCardsSmallScreen(),
              if (!ResponsiveWidget.isSmallScreen(context)) const RevenueSectionLarge() else const RevenueSectionSmall(),
              AvailableDriversTable(),
            ],
          ),
        ),
      ],
    );
  }
}

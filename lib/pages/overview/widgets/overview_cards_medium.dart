import 'package:flutter/material.dart';
import 'package:nwss_admin/pages/overview/widgets/info_card.dart';

class OverviewCardsMediumScreen extends StatelessWidget {
  const OverviewCardsMediumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            InfoCard(
              title: "Users",
              value: "32",
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

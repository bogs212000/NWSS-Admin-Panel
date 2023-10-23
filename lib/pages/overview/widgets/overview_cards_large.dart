import 'package:flutter/material.dart';
import 'package:nwss_admin/pages/overview/widgets/info_card.dart';


class OverviewCardsLargeScreen extends StatelessWidget {
  const OverviewCardsLargeScreen({super.key});


  @override
  Widget build(BuildContext context) {
   double width = MediaQuery.of(context).size.width;

    return  Row(
              children: [
                InfoCard(
                  title: "Users",
                  value: "32",
                  onTap: () {},
                ),
              ],
            );
  }
}
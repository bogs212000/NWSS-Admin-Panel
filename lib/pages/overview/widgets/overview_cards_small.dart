import 'package:flutter/material.dart';
import 'info_card_small.dart';


class OverviewCardsSmallScreen extends StatelessWidget {
  const OverviewCardsSmallScreen({super.key});


  @override
  Widget build(BuildContext context) {
   double width = MediaQuery.of(context).size.width;

    return  SizedBox(
      height: 80,
      child: Column(
        children: [

                      InfoCardSmall(
                        title: "Users",
                        value: "32",
                        onTap: () {},
                      ),
                  
        ],
      ),
    );
  }
}
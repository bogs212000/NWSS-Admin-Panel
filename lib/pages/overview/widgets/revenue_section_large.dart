// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nwss_admin/constants/controllers.dart';
import 'package:nwss_admin/constants/style.dart';
import 'package:nwss_admin/pages/overview/widgets/bar_chart.dart';
import 'package:nwss_admin/widgets/custom_text.dart';

class RevenueSectionLarge extends StatelessWidget {
  const RevenueSectionLarge({super.key});

  @override
  Widget build(BuildContext context) {
    String greeting = "";
    int hours=now.hour;

    if(hours>=6 && hours<=17){
      greeting = "Day";
    } else if(hours>=18 && hours<=5){
      greeting = "Evening";
    }
    return Column(
      children: [
        hours>=6 && hours<=17 ? Row(
          children: [
            Image.asset('assets/images/icons8-partly-cloudy-day-96.png',
                height: 70, width: 70),
            Text(
              '  Hello, have a great Day!',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w100),
            )
          ],
        ) : Row(
         children: [
           Image.asset('assets/images/icons8-night-96.png',
               height: 70, width: 70),
           Text(
             '  Hello, have a great Evening!',
             style: TextStyle(fontSize: 30, fontWeight: FontWeight.w100),
           )
         ],
       ),
        Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(vertical: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey, // Shadow color
                blurRadius: 10, // How much the shadow should blur
                offset: Offset(0, 5), // Shadow offset from the container
                spreadRadius: 0, // How much the shadow should spread
              ),
            ],
            border: Border.all(color: lightGrey, width: .5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const CustomText(
                      text: "Water Consumption",
                      size: 20,
                      weight: FontWeight.bold,
                      color: lightGrey,
                    ),
                    SizedBox(width: 600, height: 200, child: SimpleBarChart()),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 120,
                color: lightGrey,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const CustomText(
                      text: "Water Price",
                      size: 20,
                      weight: FontWeight.bold,
                      color: lightGrey,
                    ),
                    SizedBox(width: 600, height: 200, child: SimpleBarChart()),
                  ],
                ),
              ),
            ],
          ),
        )
            .animate(delay: Duration(milliseconds: 200))
            .fadeIn(duration: 200.ms, curve: Curves.easeIn),
      ],
    );
  }
}

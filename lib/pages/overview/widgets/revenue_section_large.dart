// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:nwss_admin/constants/style.dart';
import 'package:nwss_admin/pages/overview/widgets/bar_chart.dart';
import 'package:nwss_admin/pages/overview/widgets/revenue_info.dart';
import 'package:nwss_admin/widgets/custom_text.dart';
import 'package:percent_indicator/percent_indicator.dart';

class RevenueSectionLarge extends StatelessWidget {
  const RevenueSectionLarge({super.key});


  @override
  Widget build(BuildContext context) {
    return  Container(
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
                          SizedBox(
                              width: 600,
                              height: 200,
                              child: SimpleBarChart()),
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
                          SizedBox(
                              width: 600,
                              height: 200,
                              child: SimpleBarChart()),
                        ],
                      ),
                    ),
                  ],
                ),
              );
  }
}
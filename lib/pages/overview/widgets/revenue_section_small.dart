// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:nwss_admin/constants/controllers.dart';
import 'package:nwss_admin/constants/style.dart';
import 'package:nwss_admin/helpers/reponsiveness.dart';
import 'package:nwss_admin/pages/overview/widgets/bar_chart.dart';
import 'package:nwss_admin/pages/overview/widgets/price_rate_log.dart';
import 'package:nwss_admin/pages/overview/widgets/revenue_info.dart';
import 'package:nwss_admin/widgets/custom_text.dart';

class RevenueSectionSmall extends StatefulWidget {
  const RevenueSectionSmall({super.key});

  @override
  State<RevenueSectionSmall> createState() => _RevenueSectionSmallState();
}

class _RevenueSectionSmallState extends State<RevenueSectionSmall> {

  final TextEditingController searchController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  String search = "";
  String? upDown;
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
                        offset: const Offset(0, 6),
                        color: lightGrey.withOpacity(.1),
                        blurRadius: 12)
                  ],
                  border: Border.all(color: lightGrey, width: .5),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 260,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const CustomText(
                            text: "Consumed ",
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
                      width: 120,
                      height: 1,
                      color: lightGrey,
                    ),
                  SizedBox(
                      height: 260,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(children: [const CustomText(
                      text: "Current water price",
                      size: 15,
                      weight: FontWeight.bold,
                      color: lightGrey,
                    ),
                    Spacer(), Tooltip(
                              message: 'Change Price',
                              child: GestureDetector(
                                onTap: () {
                                  _showChangePrice(context);
                                },
                                child: Icon(Icons.change_circle),
                              ),
                            ),
                            SizedBox(width: 5),
                            Tooltip(
                              message: 'Log',
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => PriceRateLog()),
                                    );
                                  },
                                  child: Icon(Icons.library_books_rounded)),
                            )],),

                        ],
                      ),
                    ),
                  ],
                ),
              );
  }

  void _showChangePrice(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change water price'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Current water price:  $currentWaterPrice',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    width: ResponsiveWidget.isSmallScreen(context) ? 100 : 250,
                    child: TextField(
                      controller: priceController,
                      decoration: InputDecoration(
                        labelText: "Input price",
                        hintText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType:
                      TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                double newValue = double.tryParse(priceController.text) ?? 0.0;
                if (currentWaterPrice! < newValue) {
                  setState(() {
                    upDown = "up";
                  });
                } else {
                  setState(() {
                    upDown = "down";
                  });
                }
                try {
                  await fbStore
                      .collection('price')
                      .doc('price')
                      .update({'current': newValue});
                  await fbStore
                      .collection('price')
                      .doc('price')
                      .collection('priceUpdateHistory')
                      .doc()
                      .set({
                    'price': newValue,
                    'date': formattedDate,
                    'createdAt': now,
                    'changed': upDown
                  });

                  // Close the loading indicator
                  Navigator.of(context, rootNavigator: true).pop();

                  _showSuccess(context);
                } catch (e) {
                  // Handle errors and show an error message
                  Navigator.of(context, rootNavigator: true)
                      .pop(); // Close the loading indicator
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Update'),
            )
          ],
        );
      },
    );
  }
  void _showSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change water price'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Lottie.asset('assets/lottie/success.json',
                      height: 100, width: 100),
                  SizedBox(height: 10),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                DateTime time = DateTime.now();
                String formattedDateNow =
                DateFormat('EEEE, yyyy-MM-dd').format(time);
                String formattedTimeNow = DateFormat('h:mm a').format(time);
                try {
                  double newValue =
                      double.tryParse(priceController.text) ?? 0.0;
                  await fbStore
                      .collection('price')
                      .doc('price')
                      .update({'current': newValue});
                  fbStore
                      .collection('price')
                      .doc('price')
                      .collection('priceUpdateHistory')
                      .doc()
                      .set({
                    'price': newValue,
                    'date': formattedDateNow,
                    'createdAt': now
                  });
                } catch (e) {}
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
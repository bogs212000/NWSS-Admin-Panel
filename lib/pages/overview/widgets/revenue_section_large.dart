// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:nwss_admin/constants/controllers.dart';
import 'package:nwss_admin/constants/style.dart';
import 'package:nwss_admin/helpers/reponsiveness.dart';
import 'package:nwss_admin/pages/overview/widgets/bar_chart.dart';
import 'package:nwss_admin/widgets/custom_text.dart';

class RevenueSectionLarge extends StatefulWidget {
  RevenueSectionLarge({super.key});

  @override
  State<RevenueSectionLarge> createState() => _RevenueSectionLargeState();
}

class _RevenueSectionLargeState extends State<RevenueSectionLarge> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  List<DocumentSnapshot> searchResults = [];
  String search = "";
  String? upDown;

  @override
  void initState() {
    super.initState();

    // Add a listener to the search input
    searchController.addListener(() {
      // Call a function to fetch data from Firebase based on user input
      fetchDataFromFirebase(searchController.text);
    });
  }

  Future<void> fetchDataFromFirebase(String userInput) async {
    // Query Firebase based on the user input
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('name', isGreaterThanOrEqualTo: userInput)
        .where('name',
            isLessThan: userInput +
                'z') // Assuming you want a basic "starts with" search
        .get();

    // Update the searchResults list based on the fetched data
    setState(() {
      searchResults = querySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    String greeting = "";
    int hours = now.hour;

    if (hours >= 6 && hours <= 17) {
      greeting = "Day";
    } else if (hours >= 18 && hours <= 5) {
      greeting = "Evening";
    }
    return Column(
      children: [
        hours >= 6 && hours <= 17
            ? Row(
                children: [
                  Image.asset('assets/images/icons8-partly-cloudy-day-96.png',
                      height: 70, width: 70),
                  Text(
                    '  Hello, have a great Day!',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w100),
                  ),
                  Spacer(),
                  const CustomText(
                    text: "",
                    size: 15,
                    weight: FontWeight.bold,
                    color: lightGrey,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          _showManualPay(context);
                        },
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          onSurface: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Lottie.asset("assets/lottie/pay_animation.json",
                                height: 50, width: 50, repeat: false),
                            Text(
                              "Manual pay",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
                .animate(delay: Duration(milliseconds: 300))
                .fadeIn(duration: 300.ms, curve: Curves.easeIn)
            : Row(
                children: [
                  Image.asset('assets/images/icons8-night-96.png',
                      height: 70, width: 70),
                  Text(
                    '  Hello, have a great Evening!',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w100),
                  )
                ],
              )
                .animate(delay: Duration(milliseconds: 300))
                .fadeIn(duration: 300.ms, curve: Curves.easeIn),
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
                    Row(
                      children: [
                        const CustomText(
                          text: "Current water price   ",
                          size: 15,
                          weight: FontWeight.bold,
                          color: lightGrey,
                        ),
                        CustomText(
                          text: currentWaterPrice == null
                              ? "Fetching date, please reload the page"
                              : currentWaterPrice.toString(),
                          size: 13,
                          weight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        Spacer(),
                        const CustomText(
                          text: "Change  ",
                          size: 12,
                          weight: FontWeight.bold,
                          color: lightGrey,
                        ),
                        GestureDetector(
                            onTap: () {
                              _showChangePrice(context);
                            },
                            child: Icon(Icons.change_circle))
                      ],
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

  void _showManualPay(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Manual Pay'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              DateTime time = DateTime.now();
              String formattedDateNow =
                  DateFormat('EEEE, yyyy-MM-dd').format(time);
              String formattedTimeNow = DateFormat('h:mm a').format(time);
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "$formattedDateNow   $formattedTimeNow",
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    width: ResponsiveWidget.isSmallScreen(context) ? 100 : 250,
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          search = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Name",
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
                  SizedBox(
                      height: 50,
                      width: 250,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("user")
                            .where("name", isGreaterThanOrEqualTo: search)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Somthing went wrong!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                )
                              ],
                            );
                          } else {
                            return ListView.builder(
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                // Customize this part to show the search results as needed
                                return ListTile(
                                  title: Text(searchResults[index][
                                      'name']), // Replace with the actual field name// Replace with the actual field name
                                  // Add more widgets as needed
                                );
                              },
                            );
                          }
                        },
                      ))
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

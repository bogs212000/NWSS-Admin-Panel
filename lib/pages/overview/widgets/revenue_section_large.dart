// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:nwss_admin/constants/controllers.dart';
import 'package:nwss_admin/constants/style.dart';
import 'package:nwss_admin/functions/fetch.dart';
import 'package:nwss_admin/helpers/reponsiveness.dart';
import 'package:nwss_admin/pages/overview/widgets/bar_chart.dart';
import 'package:nwss_admin/pages/overview/widgets/price_rate_log.dart';
import 'package:nwss_admin/widgets/custom_text.dart';

class RevenueSectionLarge extends StatefulWidget {
  RevenueSectionLarge({super.key});

  @override
  State<RevenueSectionLarge> createState() => _RevenueSectionLargeState();
}

class _RevenueSectionLargeState extends State<RevenueSectionLarge> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController account = TextEditingController();
  List<DocumentSnapshot> searchResults = [];
  bool isTextExisting = true;
  String dropdownvalue = '';
  String dropdownvalue2 = 'ID1';
  String dropdownvalue1 = 'ID1';
  String search = "";
  String? upDown;
  var item;
  var brgy = [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

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

  Future<void> checkIfTextExists(
      String inputText, Function(bool) callback) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Accounts')
          .where('account_ID', isEqualTo: inputText)
          .get();
      callback(querySnapshot.docs.isNotEmpty);
    } catch (error) {
      // Handle any errors that occurred
      print('Error while checking if input text exists: $error');
    }
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
                          foregroundColor: Colors.white, disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12),
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
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('price')
                              .doc('price')
                              .snapshots(),
                          // Use .snapshots() to get a real-time stream
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // Data is still loading
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // Error occurred
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // Data loaded successfully
                              final data = snapshot.data;
                              // Process and display your data here
                              return CustomText(
                                text: data == null
                                    ? "Fetching data, please reload the page"
                                    : data['current'].toString(),
                                // Replace 'yourField' with the actual field name
                                size: 13,
                                weight: FontWeight.bold,
                                color: Colors.blue,
                              );
                            }
                          },
                        ),
                        Spacer(),
                        Tooltip(
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
                                  MaterialPageRoute(
                                      builder: (context) => PriceRateLog()),
                                );
                              },
                              child: Icon(Icons.library_books_rounded)),
                        )
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

  void _showManualPay(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Manual Pay'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${DateFormat('EEEE, yyyy-MM-dd').format(DateTime.now())}   ${DateFormat('h:mm a').format(DateTime.now())}",
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: account,
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: 'Account ID',
                      ),
                      onChanged: (text) {
                        // Update UI based on text input
                        checkIfTextExists(text, (exists) {
                          setState(() {
                            isTextExisting = exists;
                          });
                        });
                        setState(() {}); // Update the UI
                      },
                    ),
                    SizedBox(height: 8),
                    if (!isTextExisting)
                      Text(
                        'Account does not exist',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.red,
                        ),
                      )
                    else if (isTextExisting && account.text.isNotEmpty)
                      Text(
                        'Account exists',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green,
                        ),
                      ),
                    SizedBox(height: 10),
                    Text(nameController.text),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Select Month: "),
                        DropdownButton(
                          focusColor: Colors.white,
                          hint: Text("Month"),
                          value: dropdownvalue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: brgy.map((String brgy) {
                            return DropdownMenuItem(
                              value: brgy,
                              child: Text(brgy),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                            monthController.text = dropdownvalue;
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                      width:
                          ResponsiveWidget.isSmallScreen(context) ? 100 : 250,
                      child: TextField(
                        controller: amountController,
                        decoration: InputDecoration(
                          labelText: "Amount",
                          hintText: "0.0",
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
                ),
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
                    try {
                      await fbStore
                          .collection("Accounts")
                          .doc(account.text)
                          .collection("bills")
                          .doc("2023")
                          .collection("month")
                          .doc(monthController.text)
                          .set({
                        'paid?': true,
                        'createdAt': now,
                        "bills": double.parse(amountController.text),
                        "month": monthController.text,
                      });

                      Navigator.of(context).pop();
                      _showSuccess(context);
                    } catch (e) {
                      // Handle errors and show an error message
                      Navigator.of(context, rootNavigator: true)
                          .pop(); // Close the loading indicator
                    }
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Upload'),
                )
              ],
            );
          },
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

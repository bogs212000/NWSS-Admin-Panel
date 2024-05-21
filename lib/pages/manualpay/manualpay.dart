import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linear_datepicker/flutter_datepicker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/controllers.dart';
import '../../constants/style.dart';
import '../../helpers/reponsiveness.dart';
import '../../widgets/custom_text.dart';

class ManualPay extends StatefulWidget {
  const ManualPay({super.key});

  @override
  State<ManualPay> createState() => _ManualPayState();
}

class _ManualPayState extends State<ManualPay> {
  final TextEditingController dueAmount = TextEditingController();
  final TextEditingController account = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController consumptionCubicMeter = TextEditingController();
  bool isTextExisting = true;
  String? cName;
  String? cAdrress;
  String? cContactNum;
  String? date;
  String? upDown;
  List<DocumentSnapshot> searchResults = [];
  String dropdownvalue = '';
  String dropdownvalue2 = 'ID1';
  String dropdownvalue1 = 'ID1';
  String search = "";
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

  Future<void> checkIfTextExists(String inputText,
      Function(bool) callback) async {
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

  void _showSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success!'),
          content: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Lottie.asset('assets/lottie/success.json',
                    height: 100, width: 100),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error!'),
          content: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error,
                  size: 100,
                ),
                const SizedBox(height: 10),
                'Something went wrong!'.text.make(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Manual Pay'.text.bold.make(),
      ),
      body: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${DateFormat('EEEE, yyyy-MM-dd').format(
                          DateTime.now())}   ${DateFormat('h:mm a').format(
                          DateTime.now())}",
                      style: const TextStyle(fontSize: 12),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 500,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              'Enter the unique ID for the account.'
                                  .text
                                  .make(),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              SizedBox(
                                width: 300,
                                child: TextField(
                                  controller: account,
                                  keyboardType: TextInputType.name,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide:
                                      const BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      const BorderSide(color: Colors.grey),
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
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (!isTextExisting)
                            const Text(
                              'Account does not exist',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red,
                              ),
                            )
                          else
                            if (isTextExisting && account.text.isNotEmpty)
                              Column(
                                children: [
                                  Row(
                                    children: const [
                                      Text(
                                        'Account exists',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      cName != null
                                          ? Text('$cName')
                                          : const SizedBox(),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      cAdrress != null
                                          ? Text('$cAdrress')
                                          : const SizedBox(),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      cContactNum != null
                                          ? Text('$cContactNum')
                                          : const SizedBox(),
                                    ],
                                  ),
                                ],
                              ),

                          isTextExisting && account.text.isNotEmpty ? Row(children: [
                            StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Accounts')
                                  .doc(account.text)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }

                                if (!snapshot.hasData ||
                                    !snapshot.data!.exists) {
                                  return Center(
                                      child: Text('Document does not exist'));
                                }

                                var doc = snapshot.data!;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Row(children: [
                                    doc['name'].toString().text.make(),
                                  ],),
                                  Row(children: [
                                    doc['address'].toString().text.make(),
                                  ],)
                                ],);
                              },
                            ),
                          ],) : SizedBox()
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        child: Container(
                          color: Colors.blue,
                          height: 500,
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Expanded(
                                child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("biils")
                                      .where(
                                      'clientId', isEqualTo: account.text)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: const [
                                          Text(
                                            "Somthing went wrong!",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color:
                                              Color.fromARGB(255, 231, 25, 25),
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: Lottie.asset(
                                            'assets/lottie/animation_loading.json',
                                            width: 100,
                                            height: 100),
                                      );
                                    }
                                    if (snapshot.data?.size == 0) {
                                      return Center(
                                        child: Text(
                                            'Input a valid account ID!'),
                                      );
                                    }
                                    Row(children: const [
                                      TextField(
                                        decoration: InputDecoration(),
                                      )
                                    ]);
                                    return ListView(
                                      physics: BouncingScrollPhysics(),
                                      padding: EdgeInsets.only(top: 10),
                                      children: snapshot.data!.docs
                                          .map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document
                                            .data()!
                                        as Map<String, dynamic>;
                                        var due = DateFormat('yyyy-MM-dd')
                                            .format(data['dueDate'].toDate());
                                        var afd =
                                            data['billAmount'] +
                                                data['dueDateFee'];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5, bottom: 10),
                                          child: Card(
                                            shadowColor:
                                            Color.fromARGB(255, 34, 34, 34),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {

                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(10)),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          data['month']
                                                              .toString(),
                                                          maxLines: 1,
                                                          softWrap: false,
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                              FontWeight.w400),
                                                        ),
                                                        Spacer(),

                                                        Text(
                                                          '₱ ${data['billAmount']}'
                                                              .toString(),
                                                          maxLines: 1,
                                                          softWrap: false,
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                              FontWeight.w400),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20),
                                                    Row(
                                                      children: [
                                                        Text(
                                                            'Consumption(cubic meter) :'),
                                                        Spacer(),
                                                        Text(
                                                            document['consumption']
                                                                .toString()),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text('Due date :'),
                                                        Spacer(),
                                                        Text('${due}'),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text('Penalty :'),
                                                        Spacer(),
                                                        Text(
                                                            '₱${data['dueDateFee']}'),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                            'Amount after due :'),
                                                        Spacer(),
                                                        Text('₱${afd}'),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text('Status :'),
                                                        Spacer(),
                                                        data['paid?'] == true
                                                            ? Text(
                                                          'Paid',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .green),
                                                        )
                                                            : Text(
                                                          'Unpaid',
                                                          style: TextStyle(
                                                              color:
                                                              Colors.red),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
                const SizedBox(height: 30),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     SizedBox(
                //       width: 100,
                //       child: InkWell(
                //         onTap: () async {
                //           _showConfirmationDialog(context);
                //         },
                //         child: Container(
                //           decoration: BoxDecoration(
                //             color: active,
                //             borderRadius: BorderRadius.circular(20),
                //           ),
                //           alignment: Alignment.center,
                //           width: double.maxFinite,
                //           padding: const EdgeInsets.symmetric(vertical: 16),
                //           child: const CustomText(
                //             text: "Upload",
                //             color: Colors.white,
                //           ),
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: 30),
                //   ],
                // ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Upload'),
          content: const Text('Do you want to save the input data?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (account.text.isEmpty ||
                    amountController.text.isEmpty ||
                    dueAmount.text.isEmpty) {
                  _showError(context);
                } else {
                  Navigator.of(context).pop(); // Close the dialog
                  _handleUpload(context);
                  _showSuccess(context);
                }
              },
              child: const Text('Upload'),
            ),
          ],
        );
      },
    );
  }

  void _handleUpload(BuildContext context) async {
    String docId = Uuid().v4();
    try {
      await FirebaseFirestore.instance.collection("biils").doc(docId).set({
        'docId': docId,
        'clientId': account.text,
        'paid?': false,
        'createdAt': DateTime.now(),
        'billAmount': double.parse(amountController.text),
        'dueDate': Timestamp.fromDate(DateTime.parse(date!)),
        'dueDateFee': double.parse(dueAmount.text),
        'consumption': double.parse(consumptionCubicMeter.text),
        'month': monthController.text,
        'year': '2024',
      });
      consumptionCubicMeter.clear();
      amountController.clear();
      dueAmount.clear();
      Navigator.of(context).pop(); // Close the dialog
      _showSuccess(context);
    } catch (e) {
      // Handle errors and show an error message
      print('Error: $e');
      // You may want to show an error message here
    }
  }
}

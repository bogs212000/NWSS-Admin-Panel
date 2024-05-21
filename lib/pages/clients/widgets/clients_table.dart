// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nwss_admin/constants/style.dart';
import 'package:nwss_admin/pages/clients/widgets/bills.dart';
import 'package:nwss_admin/widgets/custom_text.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/controllers.dart';
import '../../../functions/fetch.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

/// Example without datasource
class ClientsTable extends StatefulWidget {
  const ClientsTable({super.key});

  @override
  State<ClientsTable> createState() => _ClientsTableState();
}

class _ClientsTableState extends State<ClientsTable> {
  @override
  Widget build(BuildContext context) {

    Future<List<DocumentSnapshot>> firebaseData() async {
      QuerySnapshot querySnapshot = await _firestore.collection('user').get();
      return querySnapshot.docs;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: active.withOpacity(.4), width: .5),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey, // Shadow color
            blurRadius: 10, // How much the shadow should blur
            offset: Offset(0, 5), // Shadow offset from the container
            spreadRadius: 0, // How much the shadow should spread
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 30),
      child: SizedBox(
        height: (56 * 7) + 40,
        child: FutureBuilder<List<DocumentSnapshot>>(
          future: firebaseData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset('assets/lottie/animation_loading.json',
                    width: 100, height: 100),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data?.isEmpty ?? true) {
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/lottie/animation_loj8u1uc.json',
                          height: 200, width: 200),
                      Text('No data yet.'),
                    ],
                  ));
            } else {
              return DataTable2(
                columnSpacing: 5,
                dataRowHeight: 40,
                headingRowHeight: 30,
                horizontalMargin: 5,
                minWidth: 600,
                columns: const [
                  DataColumn2(
                    label: Text(
                      "Name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    size: ColumnSize.L,
                  ),
                  DataColumn(
                    label: Text(
                      'Acc. ID',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Address',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Contact No.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: snapshot.data!.map((doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  return DataRow(
                    cells: [
                      DataCell(CustomText(text: data['fullname'])),
                      DataCell(CustomText(text: data['account_ID'])),
                      DataCell(CustomText(text: data['address'])),
                      DataCell(CustomText(text: data['contactNo'])),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Tooltip(
                            message: 'More',
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  account_ID = data['account_ID'];
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => BillsPage()),
                                );

                              },
                              child: Image.asset('assets/images/icons8-more.png',
                                  height: 25, width: 25),
                            ),
                          ),
                          SizedBox(width: 5),
                          Tooltip(
                            message: 'Preview',
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  accountID = data['account_ID'];
                                });
                                print(accountID);
                                calculateTotalAmount(setState);
                                _showDetails(context);

                              },
                              child: Image.asset('assets/images/icons8-preview.png',
                                  height: 25, width: 25),
                            ),
                          ),
                        ],
                      )),
                    ],
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
  void _showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // Call calculateTotalAmount to fetch the latest total amount balance
            calculateTotalAmount(setState);

            return AlertDialog(
              title: Text('Bills'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the total amount balance
                    Text('Total Amount Balance: $totalAmountBalance'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'),
                ),
              ],
            );
          },
        );
      },
    );
  }

}

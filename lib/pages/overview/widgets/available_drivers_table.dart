// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:nwss_admin/constants/style.dart';

import '../../../widgets/custom_text.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AvailableDriversTable extends StatefulWidget {
  AvailableDriversTable({Key? key}) : super(key: key);

  @override
  State<AvailableDriversTable> createState() => _AvailableDriversTableState();
}

class _AvailableDriversTableState extends State<AvailableDriversTable> {
  @override
  Widget build(BuildContext context) {
    bool showAllData = false;
    Future<List<DocumentSnapshot>> firebaseData() async {
      QuerySnapshot querySnapshot =
          await _firestore.collection('Transaction').get();
      return querySnapshot.docs;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: active.withOpacity(.4), width: .5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey, // Shadow color
            blurRadius: 10, // How much the shadow should blur
            offset: Offset(0, 5), // Shadow offset from the container
            spreadRadius: 0, // How much the shadow should spread
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox(width: 10),
              CustomText(
                text: "Last Transactions",
                color: lightGrey,
                weight: FontWeight.bold,
              ),
              Spacer(),
            ],
          ),
          SizedBox(
            height: (56 * 7) + 40,
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: firebaseData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Lottie.asset('assets/lottie/animation_loading.json', width: 100, height: 100),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data?.isEmpty ?? true) {
                  return Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/lottie/animation_loj8u1uc.json', height: 200, width: 200),
                      Text('No data yet.'),
                    ],
                  ));
                } else {
                  List<DocumentSnapshot> dataToShow = showAllData
                      ? snapshot.data!
                      : snapshot.data!.take(10).toList();
                  return DataTable2(
                    columnSpacing: 12,
                    dataRowHeight: 56,
                    headingRowHeight: 40,
                    horizontalMargin: 12,
                    minWidth: 600,
                    columns: const [
                      DataColumn2(
                        label: Text("Name"),
                        size: ColumnSize.L,
                      ),
                      DataColumn(
                        label: Text('Address'),
                      ),
                      DataColumn(
                        label: Text('Payments'),
                      ),
                      DataColumn(
                        label: Text('Action'),
                      ),
                    ],
                    rows: dataToShow.map((doc) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;
                      return DataRow(
                        cells: [
                          DataCell(CustomText(text: data['name'])),
                          DataCell(CustomText(text: data['address'])),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.money, color: Colors.blue, size: 18),
                                SizedBox(width: 5),
                                CustomText(
                                    text: data['payments_amount'].toString()),
                              ],
                            ),
                          ),
                          DataCell(
                            Container(
                              decoration: BoxDecoration(
                                color: light,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.green.shade500, width: .5),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: CustomText(
                                text: data['action'],
                                color: Colors.green.withOpacity(.7),
                                weight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: 400)).fadeIn(duration: 400.ms, curve: Curves.easeIn);
  }
}

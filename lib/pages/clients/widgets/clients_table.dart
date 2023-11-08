// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nwss_admin/constants/style.dart';
import 'package:nwss_admin/widgets/custom_text.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

/// Example without datasource
class ClientsTable extends StatelessWidget {
  const ClientsTable({super.key});

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
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 6),
              color: lightGrey.withOpacity(.1),
              blurRadius: 12)
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
                children: [
                  Lottie.asset('assets/lottie/animation_empty.json',
                      height: 100, width: 100),
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
                      'Balance',
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
                      'Water Consumption',
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
                      DataCell(CustomText(text: data['name'])),
                      DataCell(CustomText(text: data['balance_to_pay'])),
                      DataCell(CustomText(text: data['address'])),
                      DataCell(CustomText(text: data['contactNo'])),
                      DataCell(Row(

                        children: [
                          Text(
                            data['water_usage'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '  Cubic Meter ',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      )),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Tooltip(
                            message: 'More',
                            child: GestureDetector(
                              onTap: () {},
                              child: Image.asset('assets/images/icons8-more.png',
                                  height: 25, width: 25),
                            ),
                          ),
                          SizedBox(width: 5),
                          Tooltip(
                            message: 'Preview',
                            child: GestureDetector(
                              onTap: () {},
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
}

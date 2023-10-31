import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:nwss_admin/constants/style.dart';
import 'package:nwss_admin/widgets/custom_text.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

/// Example without datasource
class Clientstable extends StatelessWidget {
  const Clientstable({super.key});

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
              return const Text('Loading please wait...');
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data?.isEmpty ?? true) {
              return const Center(child: Text('No riders yet.'));
            } else {
              return DataTable2(
                columnSpacing: 10,
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
                    label: Text('Balance'),
                  ),
                  DataColumn(
                    label: Text('Address'),
                  ),
                  DataColumn(
                    label: Text('Contact No.'),
                  ),
                  DataColumn(
                    label: Text('Water Consumption'),
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
                      DataCell(CustomText(text: data['water_usage'])),
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

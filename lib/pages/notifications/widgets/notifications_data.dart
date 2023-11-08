// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nwss_admin/constants/style.dart';
import 'package:nwss_admin/widgets/custom_text.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

/// Example without datasource
class NotificationsTable extends StatefulWidget {
  const NotificationsTable({super.key});

  @override
  State<NotificationsTable> createState() => _NotificationsTableState();
}

class _NotificationsTableState extends State<NotificationsTable> {
  @override
  Widget build(BuildContext context) {
    Future<List<DocumentSnapshot>> firebaseData() async {
      QuerySnapshot querySnapshot = await _firestore
          .collection('NewsUpdate')
          .orderBy('createdAt', descending: true)
          .get();
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
                horizontalMargin: 12,
                minWidth: 600,
                columns: const [
                  DataColumn2(
                    label: Text("Title",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    size: ColumnSize.L,
                  ),
                  DataColumn(
                      label: Text(
                    'Descriptions',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  DataColumn(
                      label: Text(
                    'To',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  DataColumn(
                    label: Text(
                      'Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(''),
                  ),
                ],
                rows: snapshot.data!.map((doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  String date = "${data['date']}, ${data['time']}";
                  return DataRow(
                    cells: [
                      DataCell(
                          Text(data['title'], style: TextStyle(fontSize: 12))),
                      DataCell(Tooltip(
                          message: data['descriptions'],
                          child: Text(data['descriptions'],
                              style: TextStyle(fontSize: 12)))),
                      DataCell(
                          Text(data['filter'], style: TextStyle(fontSize: 12))),
                      DataCell(Text(date, style: TextStyle(fontSize: 12))),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Tooltip(
                            message: 'More',
                            child: GestureDetector(
                              onTap: () {},
                              child: Image.asset(
                                  'assets/images/icons8-more.png',
                                  height: 25,
                                  width: 25),
                            ),
                          ),
                          SizedBox(width: 5),
                          Tooltip(
                            message: 'Delete',
                            child: GestureDetector(
                              onTap: () {},
                              child: Image.asset(
                                  'assets/images/icons8-delete.png',
                                  height: 25,
                                  width: 25),
                            ),
                          ),
                          SizedBox(width: 5),
                          Tooltip(
                            message: 'Preview',
                            child: GestureDetector(
                              onTap: () {},
                              child: Image.asset(
                                  'assets/images/icons8-preview.png',
                                  height: 25,
                                  width: 25),
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

// ignore_for_file: prefer_const_constructors
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nwss_admin/constants/style.dart';
import 'package:nwss_admin/widgets/custom_text.dart';

import '../../loading.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

/// Example without datasource
class TransactionTable extends StatefulWidget {
  const TransactionTable({super.key});

  @override
  State<TransactionTable> createState() => _TransactionTableState();
}

class _TransactionTableState extends State<TransactionTable> {
  @override
  Widget build(BuildContext context) {
    bool loading = false;
    Future<List<DocumentSnapshot>> firebaseData() async {
      QuerySnapshot querySnapshot =
          await _firestore.collection('transactions').get();
      return querySnapshot.docs;
    }

    return loading? Loading() : Container(
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
                      "name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    size: ColumnSize.L,
                  ),
                  DataColumn(
                    label: Text(
                      'Purpose',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Amount',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Receipt',
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
                      DataCell(CustomText(text: data['modeOfPayment'])),
                      DataCell(
                        CustomText(text: (data['amount'] as double).toString()),
                      ),
                      DataCell(Row(
                        children: [
                          CachedNetworkImage(
                            height: 50,
                            width: 50,
                            imageUrl: data['ReceiptUrl'],
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ],
                      )),
                      DataCell(Row(
                        children: [
                          data['confirmed'] == false
                              ? SizedBox(
                                  width: 100,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                      setState(() {
                                        loading = true;
                                      });
                                        await FirebaseFirestore.instance
                                            .collection("Accounts")
                                            .doc(data['account_id'])
                                            .collection("bills")
                                            .doc("2023")
                                            .collection("month")
                                            .doc(data['month'])
                                            .update({
                                          "bills": 0.0,
                                          "paid?": false,
                                        });
                                        await FirebaseFirestore.instance
                                            .collection("transactions")
                                            .doc(data['doc_id'])
                                            .update({
                                          'confirmed': true,
                                        });
                                      setState(() {
                                        loading = false;
                                      });
                                      },
                                      child: Text('Confirm')))
                              : SizedBox()
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

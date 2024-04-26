// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:nwss_admin/constants/style.dart';

import '../../../widgets/custom_text.dart';
import '../../loading.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

/// Example without datasource
class TransactionTable extends StatefulWidget {
  const TransactionTable({super.key});

  @override
  State<TransactionTable> createState() => _TransactionTableState();
}

class _TransactionTableState extends State<TransactionTable> {
  List<dynamic> payments = [];

  @override
  void initState() {
    super.initState();
    fetchPayments();
  }

  Future<void> fetchPayments() async {
    final response = await http.get(
      Uri.parse('https://api.paymongo.com/v1/payments'),
      headers: {
        'Authorization': 'sk_test_2fsdysiyphUYGPJomZrbX17d',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        payments = json.decode(response.body)['data'];
      });
    } else {
      throw Exception('Failed to load payments');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool loading = false;
    Future<List<DocumentSnapshot>> firebaseData() async {
      QuerySnapshot querySnapshot = await _firestore
          .collection('clientsPayment')
          .where('confirmed?', isEqualTo: false)
          .get();
      return querySnapshot.docs;
    }

    return loading
        ? Loading()
        : Container(
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
                      child: Lottie.asset(
                          'assets/lottie/animation_loading.json',
                          width: 100,
                          height: 100),
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
                            'Payment ref ID',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'ref no.',
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
                            'Date',
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
                        Timestamp timestamp = data['createdAt'] as Timestamp;
                        DateTime dateTime = timestamp.toDate();
                        DateFormat formatter =
                            DateFormat('yyyy-MM-dd HH:mm:ss');
                        String formattedDate = formatter.format(dateTime);
                        return DataRow(
                          cells: [
                            DataCell(CustomText(text: data['name'])),
                            DataCell(CustomText(text: data['paymentId'])),
                            DataCell(CustomText(text: data['gcashRefNo'])),
                            DataCell(
                              CustomText(
                                  text: (data['amount'] as double).toString()),
                            ),
                            DataCell(
                              CustomText(text: formattedDate),
                            ),
                            DataCell(Row(
                              children: [
                                data['confirmed?'] == false
                                    ? SizedBox(
                                        width: 100,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              setState(() {
                                                loading = true;
                                              });
                                              await FirebaseFirestore.instance
                                                  .collection("biils")
                                                  .doc(data['docId'])
                                                  .update({
                                                "paid?": true,
                                              });
                                              await FirebaseFirestore.instance
                                                  .collection("clientsPayment")
                                                  .doc(data['gcashRefNo'])
                                                  .update({
                                                'confirmed?': true,
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/controllers.dart';

class BillsPage extends StatefulWidget {
  const BillsPage({super.key});

  @override
  State<BillsPage> createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Bills'.text.make(),
      ),
      body: Container(
        color: Colors.blue,
        height: double.infinity,
        width: double.infinity,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("biils")
              .where('clientId', isEqualTo: account_ID)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: const Text(
                  "Something went wrong!",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 231, 25, 25),
                  ),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset(
                  'assets/lottie/animation_loading.json',
                  width: 100,
                  height: 100,
                ),
              );
            }
            if (snapshot.data?.size == 0) {
              return Center(
                child: Text('Input a valid account ID!'),
              );
            }
            return ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(top: 10),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                var due = DateFormat('yyyy-MM-dd').format(data['dueDate'].toDate());
                var amountAfterDue = data['billAmount'] + data['dueDateFee'];
                return Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                  child: Card(
                    shadowColor: Color.fromARGB(255, 34, 34, 34),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // Handle tap
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  data['month'].toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '₱ ${data['billAmount']}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text('Consumption (cubic meter):'),
                                Spacer(),
                                Text(document['consumption'].toString()),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Due date:'),
                                Spacer(),
                                Text(due),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Penalty:'),
                                Spacer(),
                                Text('₱${data['dueDateFee']}'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Amount after due:'),
                                Spacer(),
                                Text('₱${amountAfterDue}'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Status:'),
                                Spacer(),
                                Text(
                                  data['paid?'] ? 'Paid' : 'Unpaid',
                                  style: TextStyle(
                                    color: data['paid?'] ? Colors.green : Colors.red,
                                  ),
                                ),
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
      ),
    );
  }
}

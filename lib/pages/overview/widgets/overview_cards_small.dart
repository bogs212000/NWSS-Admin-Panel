// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nwss_admin/pages/overview/widgets/info_card.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class OverviewCardsSmallScreen extends StatefulWidget {
  const OverviewCardsSmallScreen({Key? key}) : super(key: key);

  @override
  _OverviewCardsSmallScreenState createState() =>
      _OverviewCardsSmallScreenState();
}

class _OverviewCardsSmallScreenState extends State<OverviewCardsSmallScreen> {
  int? documentCount;
  int? documentCountRider;

  @override
  void initState() {
    super.initState();
    fetchDocumentCount();
  }

  Future<void> fetchDocumentCount() async {
    QuerySnapshot querySnapshot = await _firestore.collection('user').get();
    setState(() {
      documentCount = querySnapshot.size;
    });
    print('Total documents: $documentCount');
  }
  Future<void> fetchDocumentCountRider() async {
    QuerySnapshot querySnapshot = await _firestore.collection('Riders').get();
    setState(() {
      documentCountRider = querySnapshot.size;
    });
    print('Total documents: $documentCountRider');
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            InfoCard(
              title: "Clients",
              value: documentCount != null
                  ? documentCount.toString()
                  : 'Loading...',
              onTap: () {},
            ),
            InfoCard(
              title: "Checker",
              value: documentCountRider != null
                  ? documentCountRider.toString()
                  : 'Loading...',
              onTap: () {},
            ),
            // Add more InfoCards for other data here
          ],
        ),
      ],
    );
  }
}

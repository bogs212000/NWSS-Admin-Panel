// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class SimpleBarChart extends StatefulWidget {
  const SimpleBarChart({Key? key}) : super(key: key);

  @override
  _SimpleBarChartState createState() => _SimpleBarChartState();
}

class _SimpleBarChartState extends State<SimpleBarChart> {
  late Future<List<ChartBarDataItem>> _chartData;

  @override
  void initState() {
    super.initState();
    _chartData = fetchDataFromFirebase();
  }

  Future<List<ChartBarDataItem>> fetchDataFromFirebase() async {
    QuerySnapshot querySnapshot = await _firestore.collection('Consumed').get();

    return querySnapshot.docs.map((doc) {
      final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('month') && data.containsKey('value')) {
        return ChartBarDataItem(data['month'], data['value']);
      }

      // Return a default value or handle appropriately in case of missing or incorrect data
      return ChartBarDataItem('N/A', 0);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChartBarDataItem>>(
      future: _chartData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.asset('assets/lottie/animation_loading.json', width: 100, height: 100),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final List<ChartBarDataItem> data = snapshot.data!;

          final List<charts.Series<ChartBarDataItem, String>> seriesList = [
            charts.Series<ChartBarDataItem, String>(
              id: 'Consumed',
              colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blue),
              domainFn: (ChartBarDataItem sales, _) => sales.year,
              measureFn: (ChartBarDataItem sales, _) => sales.consumed,
              data: data,
            ),
          ];

          return charts.BarChart(
            seriesList,
            animate: true,
          );
        } else {
          return Center(child: Text('No data available.'));
        }
      },
    );
  }
}

class ChartBarDataItem {
  final String year;
  final int consumed;

  ChartBarDataItem(this.year, this.consumed);
}

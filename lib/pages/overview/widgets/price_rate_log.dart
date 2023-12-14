// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:nwss_admin/constants/controllers.dart';
import 'package:nwss_admin/functions/fetch.dart';
import 'package:shimmer/shimmer.dart';

class PriceRateLog extends StatefulWidget {
  const PriceRateLog({super.key});

  @override
  State<PriceRateLog> createState() => _PriceRateLogState();
}

class _PriceRateLogState extends State<PriceRateLog> {
  @override
  void initState() {
    super.initState();
    fetchCurrentWaterPrice(setState);
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text('Log'),
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 30,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("price")
              .doc('price')
              .collection("priceUpdateHistory")
              .orderBy("createdAt", descending: true)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Somthing went wrong!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 231, 25, 25),
                    ),
                  )
                ],
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset(
                    'assets/lottie/animation_loading.json',
                    width: 100,
                    height: 100),
              );
            }
            if (snapshot.data?.size == 0) {
              return Center(
                child: Text('No Update yet!'),
              );
            }
            Row(children: [
              TextField(
                decoration: InputDecoration(),
              )
            ]);
            return AnimationLimiter(
              child: ListView(
                physics: snapshot.data!.size <= 4
                    ? NeverScrollableScrollPhysics()
                    : BouncingScrollPhysics(),
                padding: EdgeInsets.only(top: 0),
                children:
                    snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return AnimationConfiguration.staggeredList(
                    position: snapshot.data!.size,
                    delay: Duration(milliseconds: 200),
                    child: SlideAnimation(
                      duration: Duration(milliseconds: 2500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: FadeInAnimation(
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: Duration(milliseconds: 2500),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, bottom: 10),
                          child: Card(
                            shadowColor: Color.fromARGB(255, 34, 34, 34),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: data['changed'] != 'up'
                                      ? Colors.green.withOpacity(0.7)
                                      : Colors.red.withOpacity(0.7),
                                  borderRadius:
                                      BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Narra Water Supply System',
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Spacer(),
                                      Text(
                                        data['date'],
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w200),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    children: [
                                      Text(
                                        data['price'].toString(),
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      data['changed'] == 'up'
                                          ? Icon(Icons.upload)
                                          : Icon(Icons.download)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}

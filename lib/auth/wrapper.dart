// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nwss_admin/layout.dart';
import 'package:nwss_admin/pages/authentication/authentication.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? email = FirebaseAuth.instance.currentUser?.email;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('admin')
          .doc('$email')
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> userData) {
        if (!userData.hasData) {
          return Center(
            child: Lottie.asset('assets/lottie/animation_loading.json', width: 100, height: 100),
          );
        } else if (userData.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.asset('assets/lottie/animation_loading.json', width: 100, height: 100),
          );
        } else if (userData.hasError) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Something went wrong!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 231, 25, 25),
                ),
              ),
            ],
          );
        } else if (userData.hasData) {
          return Builder(
            builder: (
              context,
            ) {
              if (userData.data!['role'] == 'admin') {
                return SiteLayout();
              } else {
                return AuthenticationPage();
              }
            },
          );
        } else {
          return AuthenticationPage();
        }
      },
    );
  }
}

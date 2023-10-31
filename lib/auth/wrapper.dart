// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nwss_admin/layout.dart';
import 'package:nwss_admin/pages/authentication/authentication.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(width: 5),
                Text(
                  "Loading please wait...",
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.blueGrey,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        } else if (userData.connectionState == ConnectionState.waiting) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(width: 5),
                Text(
                  "Loading please wait...",
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.blueGrey,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
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

// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nwss_admin/constants/controllers.dart'; // Make sure you import your controllers correctly

class Maintenance extends StatefulWidget {
  Maintenance({Key? key}) : super(key: key);

  @override
  State<Maintenance> createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey, // Shadow color
              blurRadius: 10, // How much the shadow should blur
              offset: Offset(0, 5), // Shadow offset from the container
              spreadRadius: 0, // How much the shadow should spread
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/icons8-engineering-96.png',
                      scale: 2),
                  SizedBox(width: 10),
                  Text('Maintenance'),
                ]),
            Row(
              children: [
                Text('Maintenance mode '),
                SizedBox(width: 10),
                CupertinoSwitch(
                  activeColor: Colors.green.shade900,
                  thumbColor: Colors.white,
                  trackColor: Colors.grey,
                  value: maintenanceMode!,
                  onChanged: (value) async {
                    await fbStore
                        .collection('App Settings')
                        .doc('maintenance')
                        .update({'maintenance': value});

                    setState(() {
                      maintenanceMode = value;
                    });
                    _showDialogSuccess();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 500))
        .fadeIn(duration: 500.ms, curve: Curves.easeIn);
  }

  void _showDialogSuccess() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Saved'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Successfully Update'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showDialogError() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('An error occurred. Please try again later.'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

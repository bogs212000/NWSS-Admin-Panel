// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nwss_admin/constants/controllers.dart'; // Make sure you import your controllers correctly

class ReleaseMode extends StatefulWidget {
  ReleaseMode({Key? key}) : super(key: key);

  @override
  State<ReleaseMode> createState() => _ReleaseModeState();
}

class _ReleaseModeState extends State<ReleaseMode> {
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
                  Image.asset('assets/images/icons8-play-store-96.png', scale: 2),
                  SizedBox(width: 10),
                  Text('Google Play'),
                ]),
            Row(
              children: [
                Text('Release mode '),
                SizedBox(width: 10),
                CupertinoSwitch(
                  // overrides the default green color of the track
                  activeColor: Colors.green.shade900,
                  // color of the round icon, which moves from right to left
                  thumbColor: Colors.white,
                  // when the switch is off
                  trackColor: Colors.green.shade900,
                  // boolean variable value
                  value: releaseMode!,
                  // changes the state of the switch
                  onChanged: (value) => setState(() => releaseMode = value),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateReleaseMode(bool newValue) async {
    releaseMode = newValue;
    try {
      await fbStore.collection('App Settings').doc('release').update({
        'releaseMode': releaseMode,
      });
      _showDialogSuccess();
    } catch (e) {
      _showDialogError();
    }
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

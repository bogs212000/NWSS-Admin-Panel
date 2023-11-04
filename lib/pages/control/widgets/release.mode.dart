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
      child: Row(
        children: [
          Text('Release mode '),
          Checkbox(
            value: releaseMode, // Make sure 'value' is a boolean variable
            onChanged: (newValue) {
              setState(() {
                updateReleaseMode(newValue!);
              });
            }, // Make sure 'onChanged' is a function to handle checkbox changes
          ),
        ],
      ),
    );
  }

  void updateReleaseMode(bool newValue) {
    releaseMode = newValue;
    fbStore.collection('App Settings').doc('release').update({
      'releaseMode': releaseMode,
    });
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:nwss_admin/constants/controllers.dart';
import 'package:nwss_admin/helpers/reponsiveness.dart';

class Facebook extends StatefulWidget {
  const Facebook({super.key});

  @override
  State<Facebook> createState() => _FacebookState();
}

class _FacebookState extends State<Facebook> {
  final TextEditingController facebookController =
  TextEditingController();
  bool isSaving = false;
  bool isTextFieldEmpty = true;

  @override
  void initState() {
    super.initState();

    facebookController.addListener(() {
      setState(() {
        isTextFieldEmpty = facebookController.text.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 200,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
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
                  Image.asset('assets/images/icons8-facebook-96.png', scale: 2),
                  SizedBox(width: 10),
                  Text('Facebook Page', style: TextStyle(fontSize: 12),),
                  Spacer(),
                  GestureDetector(
                      onTap: () {},
                      child: Icon(Icons.arrow_circle_right_outlined,
                          color: Colors.grey)),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  Tooltip(
                    message: fbLink == null || fbLink == "" ? '...' : fbLink,
                    child: Column(
                      children: [
                        Icon(Icons.online_prediction, color: Colors.green),
                        Text(
                          'Current link',
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      width: ResponsiveWidget.isSmallScreen(context) ? 100 : 120,
                      child: TextField(
                        controller: facebookController,
                        decoration: InputDecoration(
                          labelText: "Link",
                          hintText: "https://.....",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (text) {
                          setState(() {
                            isTextFieldEmpty = text.isEmpty;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: isTextFieldEmpty || isSaving
                        ? null
                        : () async {
                      setState(() {
                        isSaving = true;
                      });

                      try {
                        await fbStore
                            .collection('App Settings')
                            .doc('Facebook')
                            .update({
                          'Link': facebookController.text
                              .toString()
                              .trim(),
                        });
                        facebookController.clear();
                      } catch (e) {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'An error occurred. Please try again later.'),
                                  // You can add more error information here if needed.
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } finally {
                        setState(() {
                          isSaving = false;
                        });
                      }
                    },
                    child: isSaving
                        ? Lottie.asset('assets/lottie/animation_loading.json',
                        width: 50, height: 50)
                        : Text('Save'),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: 300)).fadeIn(duration: 300.ms, curve: Curves.easeIn);
  }
}

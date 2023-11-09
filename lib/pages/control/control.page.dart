// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:nwss_admin/constants/controllers.dart';
import 'package:nwss_admin/helpers/reponsiveness.dart';
import 'package:nwss_admin/pages/control/widgets/fb_link.dart';
import 'package:nwss_admin/pages/control/widgets/force_update.dart';
import 'package:nwss_admin/pages/control/widgets/guide.dart';
import 'package:nwss_admin/pages/control/widgets/maintenance.dart';
import 'package:nwss_admin/pages/control/widgets/release.mode.dart';
import 'package:nwss_admin/pages/control/widgets/terms_and_conditions.dart';
import 'package:nwss_admin/widgets/custom_text.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          return Row(
            children: [
              Container(
                  margin: EdgeInsets.only(
                    top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6,
                  ),
                  child: CustomText(
                    text: menuController.activeItem.value,
                    size: 24,
                    weight: FontWeight.bold,
                  )),
            ],
          );
        }),
        Column(
          children: [
            SizedBox(height: 20),
            // Row(
            //   children: [
            //     SizedBox(
            //       width: 100,
            //       child: Lottie.asset('assets/lottie/animation_anime_girl.json',
            //           height: 100, width: 100, repeat: false),
            //     ),
            //     controlNote!.isNotEmpty
            //         ? Expanded(
            //             child: Container(
            //               padding: EdgeInsets.all(20),
            //               decoration: BoxDecoration(
            //                 color: Colors.red.shade100,
            //                 borderRadius: BorderRadius.only(
            //                   topLeft: Radius.circular(20),
            //                   topRight: Radius.circular(20),
            //                   bottomRight: Radius.circular(20),
            //                 ),
            //               ),
            //               child: Text("$controlNote"),
            //             ),
            //           )
            //         : Text('...'),
            //   ],
            // ),
            SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final isSmallScreen = ResponsiveWidget.isCustomSize(context) ||
                    ResponsiveWidget.isSmallScreen(context);
                return isSmallScreen
                    ? Column(
                        children: [
                          TermsAndConditions(),
                          UserGuide(),
                          Facebook(),
                        ],
                      )
                    : Column(
                      children: [
                        Row(
                            children: [
                              TermsAndConditions(),
                              UserGuide(),
                              Facebook(),
                            ],
                          ),
                        Row(children: [
                          ReleaseMode(),
                          Maintenance(),
                          ForceUpdate(),

                        ],)
                      ],
                    );
              },
            ),
          ],
        ),
      ],
    );
  }
}

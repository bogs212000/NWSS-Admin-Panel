import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nwss_admin/constants/controllers.dart';
import 'package:nwss_admin/helpers/reponsiveness.dart';
import 'package:nwss_admin/pages/control/widgets/guide.dart';
import 'package:nwss_admin/pages/control/widgets/maintenance.dart';
import 'package:nwss_admin/pages/control/widgets/release.mode.dart';
import 'package:nwss_admin/pages/control/widgets/terms_and_conditions.dart';
import 'package:nwss_admin/widgets/custom_text.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6),
                child: CustomText(
                  text: menuController.activeItem.value,
                  size: 24,
                  weight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            SizedBox(height: 50),
            TermsAndConditions(),
            UserGuide(),
            ReleaseMode(),
            Maintenance(),
          ],
        ),
      ],
    );
  }
}

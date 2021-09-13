import 'package:flutter/material.dart';
import 'package:settings/view/widgets/master_detail_utils.dart';
import 'package:settings/view/widgets/master_page.dart';

class MasterDetailContainer extends StatelessWidget {
  const MasterDetailContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: isTablet(context)
              ? kTabletMasterContainerWidth
              : MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: const MasterPage(),
        ),
      ],
    );
  }
}

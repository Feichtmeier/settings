import 'package:flutter/material.dart';

class SliderValueMarker extends StatelessWidget {
  const SliderValueMarker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Theme.of(context).dividerColor,
    );
  }
}

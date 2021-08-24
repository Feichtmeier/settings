import 'package:flutter/material.dart';
import 'package:settings/view/widgets/master_detail_utils.dart';
import 'package:settings/view/widgets/menu_item.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key, required this.item}) : super(key: key);

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          title: Text(
            item.name,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
          leading: isTablet(context)
              ? null
              : BackButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 22.0),
          child: Center(child: item.details),
        ),
      ),
    );
  }
}

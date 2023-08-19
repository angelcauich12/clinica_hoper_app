import 'package:flutter/material.dart';
import 'package:hope_app/widgets/widgets.dart';

class AppointmentList extends StatelessWidget {
  const AppointmentList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (context, index) {
          return AppointmentCard();
        },
      ),
    );
  }
}

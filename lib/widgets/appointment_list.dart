import 'package:flutter/material.dart';
import 'package:hope_app/widgets/widgets.dart';

class AppointmentList extends StatelessWidget {
  int length;

  AppointmentList({required this.length});

  @override
  Widget build(BuildContext context) {
    Future<void> onRefresh() async {
      print('se ejecuta el refresh');
      // await orderProvider.getOrdenes();
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: length,
        itemBuilder: (context, index) {
          return AppointmentCard();
        },
      ),
    );
  }
}

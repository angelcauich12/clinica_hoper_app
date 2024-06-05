import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';

class StatusLabel extends StatelessWidget {
  final  String?  status;
  final Colors? color;
  const StatusLabel({super.key, this.status, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: status == 'Confirmada' ? ThemeProvider.blue : ThemeProvider.lightRed,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 2,
      ),
      child: Text(
        status ?? 'Sin estado',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
          color: ThemeProvider.white,
        ),
      ),
    );
  }
}

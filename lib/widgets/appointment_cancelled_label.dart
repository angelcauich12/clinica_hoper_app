import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';

class CanceledLabel extends StatelessWidget {
  const CanceledLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeProvider.lightRed,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 2,
      ),
      child: Text(
        'Cancelada',
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

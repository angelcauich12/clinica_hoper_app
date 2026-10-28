import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';

class FloatingActionButtonsCalendar extends StatelessWidget {
  final void Function() onPressedSucess;
  final void Function() onPressedClose;
  const FloatingActionButtonsCalendar(
      {super.key, required this.onPressedSucess, required this.onPressedClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton.filled(
            style: TextButton.styleFrom(
                backgroundColor: ThemeProvider.primaryColor),
            onPressed: onPressedClose,
            icon: const Icon(Icons.close)),
        IconButton.filled(
             style: TextButton.styleFrom(
                backgroundColor: ThemeProvider.primaryColor),
            onPressed: onPressedSucess, icon: const Icon(Icons.check_outlined))
      ],
    );
  }
}

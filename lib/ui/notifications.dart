import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';

class Notifications {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String message) {
    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Preferences.isDarkMode
            ? ThemeProvider.darkColor
            : ThemeProvider.lightColor,
        dismissDirection: DismissDirection.startToEnd,
        content: Text(
          message,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ));
    messengerKey.currentState!.showSnackBar(snackBar);
  }

  static showSnackBarWithButton(
      String message, VoidCallback onPressed, String label) {
    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Preferences.isDarkMode
            ? ThemeProvider.darkColor
            : ThemeProvider.lightColor,
        dismissDirection: DismissDirection.startToEnd,
        action: SnackBarAction(
          onPressed: onPressed,
          label: label,
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          textAlign: TextAlign.start,
        ));
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}

import 'package:flutter/material.dart';
import 'package:hope_app/shared/preferences.dart';

class SocialMediaButton extends StatelessWidget {
  String imagePath;
  VoidCallback onTap;

  SocialMediaButton({required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: (Preferences.isDarkMode) ? Colors.black54 : Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10),
          color: (Preferences.isDarkMode) ? Colors.grey.withAlpha(30) : Colors.grey[100],
        ),
        child: Image.asset(
          imagePath,
          height: 30,
        ),
      ),
    );
  }
}

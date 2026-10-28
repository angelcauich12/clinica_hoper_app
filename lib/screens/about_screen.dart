import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';

class AboutScreen extends StatelessWidget {
  static const String routeName = 'acerca-de';

  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Preferences.isDarkMode ? ThemeProvider.darkColor : Colors.grey[100],
            appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Acerca de',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Preferences.isDarkMode
                ? ThemeProvider.white
                : ThemeProvider.brown,
          ),
        ),
        actions: const [
          // PopupMenuList(),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/itsoft.png'),
              height: 150,
            ),
            Text(
              'Desarrollado por:',
              style: TextStyle(
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                height: 2,
              ),
            ),
            Text(
              'ItSoft Services de Mexico, S.A. de C.V.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
                height: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

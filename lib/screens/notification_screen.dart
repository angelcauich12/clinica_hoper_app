import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';

class NotificationScreen extends StatelessWidget {
  static const String routeName = 'notifications';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Notificaciones',
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
      body: const Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: FadeInImage(
              placeholder: AssetImage('assets/loading.gif'),
              image: AssetImage('assets/images/underconstruction.png'),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: Text(
                  'Módulo en Desarrollo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'Anton',
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          )
        ],
      ),
    );
  }
}

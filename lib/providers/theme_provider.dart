import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData currentTheme;
  static Color lightColor = const Color.fromARGB(255, 1, 16, 93);
  static Color darkColor = const Color.fromRGBO(240, 171, 0, 1);
  static Color blueColor = const Color.fromARGB(255, 14, 30, 151);
  static Color lightGrey = const Color.fromARGB(255, 126, 126, 126);
  static Color white = const Color.fromARGB(255, 255, 255, 255);
  static Color brown = const Color.fromARGB(255, 41, 41, 41);
  static Color lightBrown = const Color.fromARGB(255, 85, 83, 83);

  static Color transparent = Colors.transparent;

  ThemeProvider({
    required isDarkmode,
    lightColor = const Color.fromARGB(255, 1, 16, 93),
    darkColor = const Color.fromRGBO(240, 171, 0, 1),
  }) : currentTheme = isDarkmode
            ? ThemeData.dark().copyWith(
                appBarTheme: AppBarTheme(
                  backgroundColor: transparent,
                  // iconTheme: const IconThemeData(
                  //   color: Colors.white,
                  // ),
                  titleTextStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: darkColor,
                  foregroundColor: Colors.white,
                ),
                bottomNavigationBarTheme:
                    BottomNavigationBarThemeData(selectedItemColor: darkColor),
                switchTheme: SwitchThemeData(
                  thumbColor: MaterialStateProperty.all(darkColor),
                  trackColor: MaterialStateProperty.all(
                      const Color.fromRGBO(240, 171, 0, 0.5)),
                ),
                expansionTileTheme: ExpansionTileThemeData(
                  backgroundColor: Colors.grey.shade800,
                  textColor: darkColor,
                  iconColor: darkColor,
                ),

                // popupMenuTheme: const PopupMenuThemeData(
                //   color: Colors.white,
                // ),
              )
            : ThemeData.light().copyWith(
                appBarTheme: AppBarTheme(
                  backgroundColor: transparent,
                  iconTheme: const IconThemeData(color: Colors.white, shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 10.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ]),
                  titleTextStyle: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: lightColor,
                  foregroundColor: Colors.white,
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  selectedItemColor: lightColor,
                  unselectedItemColor: Colors.grey,
                ),
                switchTheme: SwitchThemeData(
                  thumbColor: MaterialStateProperty.all(lightColor),
                  trackColor: MaterialStateProperty.all(
                      const Color.fromRGBO(23, 0, 155, 0.5)),
                ),
                expansionTileTheme: ExpansionTileThemeData(
                  backgroundColor: Colors.grey.shade200,
                  textColor: lightColor,
                  iconColor: lightColor,
                ),
                // popupMenuTheme: const PopupMenuThemeData(
                //   color: Colors.black,
                // ),
              );

  setLightMode() {
    currentTheme = ThemeData.light().copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: transparent,
        iconTheme: const IconThemeData(color: Colors.white, shadows: [
          Shadow(
            offset: Offset(2.0, 2.0),
            blurRadius: 10.0,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ]),
        titleTextStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: lightColor,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: lightColor,
        unselectedItemColor: Colors.grey,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(lightColor),
        trackColor:
            MaterialStateProperty.all(const Color.fromRGBO(23, 0, 155, 0.5)),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: Colors.grey.shade200,
        textColor: lightColor,
        iconColor: lightColor,
      ),
      // popupMenuTheme: const PopupMenuThemeData(
      //   color: Colors.black,
      // ),
    );
    notifyListeners();
  }

  setDarkMode() {
    currentTheme = ThemeData.dark().copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: transparent,
        // iconTheme: const IconThemeData(
        //   color: Colors.white,
        // ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkColor,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme:
          BottomNavigationBarThemeData(selectedItemColor: darkColor),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(darkColor),
        trackColor:
            MaterialStateProperty.all(const Color.fromRGBO(240, 171, 0, 0.5)),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: Colors.grey.shade800,
        textColor: darkColor,
        iconColor: darkColor,
      ),
      // popupMenuTheme: const PopupMenuThemeData(
      //   color: Colors.white,
      // ),
    );
    notifyListeners();
  }
}

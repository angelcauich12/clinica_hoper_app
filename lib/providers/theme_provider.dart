import 'package:flutter/material.dart';

// const Color(0xffE84855);

class ThemeProvider extends ChangeNotifier {
  ThemeData currentTheme;
  static Color blueColor = const Color(0xff3DA5D9);
  static Color lightGrey = const Color.fromARGB(255, 126, 126, 126);
  static Color white = const Color.fromARGB(255, 255, 255, 255);
  static Color brown = const Color.fromARGB(255, 41, 41, 41);
  static Color lightRed = const Color(0xffD11149);
  static Color darkColor = const Color(0xff1E2019);

  static Color transparent = Colors.transparent;

  ThemeProvider({
    required isDarkmode,
    lightColor = const Color(0xff3DA5D9),
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
                    const Color.fromARGB(255, 129, 208, 248),
                  ),
                ),
                expansionTileTheme: ExpansionTileThemeData(
                  backgroundColor: Colors.grey.shade200,
                  textColor: lightColor,
                  iconColor: lightColor,
                ),
                datePickerTheme: DatePickerThemeData(
                  headerBackgroundColor: lightColor,
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
        backgroundColor: blueColor,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: blueColor,
        unselectedItemColor: Colors.grey,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(blueColor),
        trackColor: MaterialStateProperty.all(
          const Color.fromARGB(255, 129, 208, 248),
        ),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: Colors.grey.shade200,
        textColor: blueColor,
        iconColor: blueColor,
      ),
      datePickerTheme: DatePickerThemeData(
        headerBackgroundColor: blueColor,
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

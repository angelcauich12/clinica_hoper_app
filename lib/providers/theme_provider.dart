import 'package:flutter/material.dart';

// const Color(0xffE84855);

class ThemeProvider extends ChangeNotifier {
  ThemeData currentTheme;
  static Color lightColor = const Color(0xff454545);
  static Color secondColor = const Color(0xff126276);
  static Color thirdColor = const Color.fromARGB(255, 54, 54, 54);
  static Color fourColor = const Color(0xffffffff);
  static Color lightGrey = const Color.fromARGB(255, 149, 148, 148);
  static Color? lightGrey2 = Colors.grey[100];
  static Color white = const Color.fromARGB(255, 255, 255, 255);
  static Color brown = const Color.fromARGB(255, 41, 41, 41);
  static Color blue =  Colors.blue;
  static Color lightRed = const Color(0xffD11149);
  static Color green = Colors.green;
  static Color darkGreen = const Color.fromARGB(255, 59, 121, 60);
  static Color darkColor = const Color(0xff1E2019);
  static Color yellowColor = const Color(0xFFF0AB00);
  static Color primaryColor = const Color(0xff247BA0);

  static LinearGradient goldenColor = const LinearGradient(
    colors: [Color(0xffe8e22e), Color(0xfff5b223)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static LinearGradient secondGradientColor =  LinearGradient(
    colors: [
      primaryColor,
      Color.fromARGB(255, 25, 153, 185),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static Color roundedButtonColor = const Color(0xFF667761);

  static Color transparent = Colors.transparent;

  ThemeProvider({required isDarkmode})
      : currentTheme = isDarkmode
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
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    selectedItemColor: yellowColor),
                switchTheme: SwitchThemeData(
                  thumbColor: MaterialStateProperty.all(yellowColor),
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
                  backgroundColor: secondColor,
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
                  backgroundColor: secondColor,
                  foregroundColor: Colors.white,
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  selectedItemColor: white,
                  unselectedItemColor: white.withOpacity(0.2),
                ),
                switchTheme: SwitchThemeData(
                  thumbColor: MaterialStateProperty.all(secondColor),
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
        backgroundColor: secondColor,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: secondColor,
        unselectedItemColor: Colors.grey,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(secondColor),
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
          BottomNavigationBarThemeData(selectedItemColor: yellowColor),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(yellowColor),
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

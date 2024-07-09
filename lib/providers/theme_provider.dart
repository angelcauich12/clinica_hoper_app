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
  static Color blue = Colors.blue;
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
  static LinearGradient secondGradientColor = LinearGradient(
    colors: [
      primaryColor,
      const Color.fromARGB(255, 25, 153, 185),
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
                  backgroundColor: secondColor,
                  // iconTheme: const IconThemeData(
                  //   color: Colors.white,
                  // ),
                  titleTextStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  selectedItemColor: white,
                  unselectedItemColor: white.withOpacity(0.2),
                ),
                switchTheme: SwitchThemeData(
                  thumbColor: MaterialStateProperty.all(white),
                  trackColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 25, 153, 185)),
                ),
                expansionTileTheme: ExpansionTileThemeData(
                  backgroundColor: Colors.grey.shade800,
                  textColor: darkColor,
                  iconColor: darkColor,
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(primaryColor))),
                iconButtonTheme: IconButtonThemeData(
                    style: ButtonStyle(
                        iconColor: MaterialStatePropertyAll(white))))
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
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  selectedItemColor: white,
                  unselectedItemColor: white.withOpacity(0.2),
                ),
                switchTheme: SwitchThemeData(
                  thumbColor: MaterialStateProperty.all(lightGrey),
                  trackColor: MaterialStateProperty.all(Colors.grey.shade400),
                ),
                expansionTileTheme: ExpansionTileThemeData(
                  backgroundColor: Colors.grey.shade200,
                  textColor: lightColor,
                  iconColor: lightColor,
                ),
                datePickerTheme: DatePickerThemeData(
                  headerBackgroundColor: lightColor,
                ),
                iconButtonTheme: IconButtonThemeData(
                    style: ButtonStyle(
                        //  backgroundColor: MaterialStatePropertyAll(primaryColor),
                        iconColor: MaterialStatePropertyAll(white)))
                // popupMenuTheme: const PopupMenuThemeData(
                //   color: Colors.black,
                // ),
                );

  setLightMode() {
    currentTheme = ThemeData.light().copyWith(
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
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: white,
          unselectedItemColor: white.withOpacity(0.2),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.all(lightGrey),
          trackColor: MaterialStateProperty.all(Colors.grey.shade400),
        ),
        expansionTileTheme: ExpansionTileThemeData(
          backgroundColor: Colors.grey.shade200,
          textColor: lightColor,
          iconColor: lightColor,
        ),
        datePickerTheme: DatePickerThemeData(
          headerBackgroundColor: lightColor,
        ),
        iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
                // backgroundColor: MaterialStatePropertyAll(primaryColor),
                iconColor: MaterialStatePropertyAll(white))));
    notifyListeners();
  }

  setDarkMode() {
    currentTheme = ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: secondColor,
          // iconTheme: const IconThemeData(
          //   color: Colors.white,
          // ),
          titleTextStyle: const TextStyle(
            color: Colors.white,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: white,
          unselectedItemColor: white.withOpacity(0.2),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.all(white),
          trackColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 25, 153, 185)),
        ),
        expansionTileTheme: ExpansionTileThemeData(
          backgroundColor: Colors.grey.shade800,
          textColor: darkColor,
          iconColor: darkColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(primaryColor))),
        iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
            
                iconColor: MaterialStatePropertyAll(white))));
    notifyListeners();
  }
}

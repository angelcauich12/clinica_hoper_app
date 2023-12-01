import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/screens/screens.dart';

class NavbarProvider extends ChangeNotifier {
  List<NavbarDTO> items = [
    NavbarDTO(
      label: 'Inicio',
      iconData: const Icon(Icons.home_outlined, size: 30),
      widget: HomeScreen(),
    ),
    NavbarDTO(
      label: 'Mis Citas',
      iconData: const Icon(Icons.calendar_month_outlined, size: 30),
      widget: const MyAppointmentsScreen(),
    ),
    NavbarDTO(
      label: 'Configuración',
      iconData: const Icon(FontAwesomeIcons.gears),
      widget: const SettingsScreen(),
    ),
  ];

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int selectedIndex) {
    _selectedIndex = selectedIndex;
    notifyListeners();
  }
}

class NavbarDTO {
  Widget? widget;
  String? label;
  Widget? iconData;

  NavbarDTO({this.widget, this.label, this.iconData});
}

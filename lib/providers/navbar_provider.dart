import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/shared/preferences.dart';

class NavbarProvider extends ChangeNotifier {
  User apiUser = User.fromJson(Preferences.apiUser);

  List<NavbarDTO> get items {
    List<NavbarDTO> items = [
      NavbarDTO(
        label: 'Inicio',
        iconData: const Icon(FontAwesomeIcons.houseChimneyWindow, size: 25),
        widget: const HomeScreen(),
      ),
      NavbarDTO(
        label: 'Mis Citas',
        iconData: const Icon(FontAwesomeIcons.calendarDay, size: 25),
        widget: const MyAppointmentsScreen(),
        requiresProfile: true
      ),
      // NavbarDTO(
      //   label: 'Configuración',
      //   iconData: const Icon(FontAwesomeIcons.gears),
      //   widget: const SettingsScreen(),
    ];

    // Agregar el ítem "Horarios" solo si el usuario es un Doctor
    if (apiUser.miPerfil.nombre == 'Doctor') {
      items.add(
        NavbarDTO(
          label: 'Horarios',
          iconData: const Icon(FontAwesomeIcons.calendarDays, size: 25),
          widget: const ManageScheduleScreen(),
        ),
      );
    }

    return items;
  }

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int selectedIndex) {
    _selectedIndex = selectedIndex;
    notifyListeners();
  }
}

class NavbarDTO {
  final Widget? widget;
  final String? label;
  final Widget? iconData;
  final bool requiresProfile;
  NavbarDTO({this.widget, this.label, this.iconData, this.requiresProfile = false});
}

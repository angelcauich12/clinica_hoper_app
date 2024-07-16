import 'package:flutter/material.dart';
import 'package:hope_app/providers/navbar_provider.dart';
import 'package:hope_app/providers/theme_provider.dart';
import 'package:hope_app/utilities/general_functions.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final mp = Provider.of<NavbarProvider>(context);
    final secondColor = ThemeProvider.secondColor;
    return BottomNavigationBar(
        backgroundColor: secondColor,
        currentIndex: mp.selectedIndex,
        onTap: (value) {
          final selectedItem = mp.items[value];
          if (selectedItem.requiresProfile && mp.apiUser.miPerfil.nombre == 'guest') {
            GeneralFunctions.showGuestAlert(context);
          } else {
            mp.selectedIndex = value;
          }
        },
        items: mp.items.map((e) => BottomNavigationBarItem(label: e.label,icon: e.iconData!,)).toList());
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  static const String routeName = 'inicio';

  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final mp = Provider.of<NavbarProvider>(context);

    return Scaffold(
      drawer: const CustomDrawer(),
      body: mp.items[mp.selectedIndex].widget!,
      bottomNavigationBar: const CustomBottomNavigationBar(),
      floatingActionButton:(mp.items[mp.selectedIndex].label!.contains('Configuración'))
              ? FloatingActionButton(
                  child: const Icon(
                    FontAwesomeIcons.question,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, AboutScreen.routeName),
                )
              : null,
    );
  }
}

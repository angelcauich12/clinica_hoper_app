import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:provider/provider.dart';

import '../screens/screens.dart';
import '../services/services.dart';

class GuestDialog extends StatelessWidget {
  const GuestDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal()),
        backgroundColor: Colors.grey[100],
        contentPadding: EdgeInsetsDirectional.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: size.height * 0.2,
              decoration: BoxDecoration(color: ThemeProvider.primaryColor),
              child: Icon(Icons.warning_amber_rounded, size: size.height * 0.2, color:Colors.grey[100], ),
            ),
            const SizedBox(height: 10,),
            const Text(
              'Necesita iniciar sesión',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                  'Es necesario iniciar sesión para acceder a este módulo.'),
            )
          ],
        ),
        actions: [
             TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              backgroundColor: ThemeProvider.lightRed,
            ),
            child: Text(
              'Cerrar',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                color: ThemeProvider.white,
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                backgroundColor: ThemeProvider.secondColor),
            onPressed: () async {
               final authService = Provider.of<AuthService>(context, listen: false);
               await authService.logout();
            Future.microtask(
              () {
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
            );
            },
            child: Text(
              'Iniciar sesión',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                color: ThemeProvider.white,
              ),
            ),
          ),
        ],
        );
  }
}

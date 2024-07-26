import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';


class GuestDialog extends StatelessWidget {
final String? title;
final IconData? icon;
final String? textCloseButton;
final String? textConfirmButton;
final String? textBody;
final void Function() onPressedCloseButton;
final void Function() onPressedConfirmButton;
const GuestDialog({super.key, this.title, this.icon, this.textCloseButton, 
this.textConfirmButton, required this.onPressedCloseButton, required this.onPressedConfirmButton, this.textBody});

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
              child: Icon(icon ?? Icons.warning_amber_rounded, size: size.height * 0.2, color:Colors.grey[100], ),
            ),
            const SizedBox(height: 10,),
             Text(
              title ?? 'Necesita iniciar sesión',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            ),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                  textBody ?? 'Es necesario iniciar sesión para acceder a este módulo.'),
            )
          ],
        ),
        actions: [
             TextButton(
            onPressed: onPressedCloseButton ,
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              backgroundColor: ThemeProvider.lightRed,
            ),
            child: Text(
            textCloseButton ?? 'Cerrar',
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
            onPressed: onPressedConfirmButton,
            child: Text(
            textConfirmButton ?? 'Iniciar sesión',
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

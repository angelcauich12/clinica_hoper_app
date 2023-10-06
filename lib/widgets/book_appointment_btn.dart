import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';

class BookAppointmentBtn extends StatelessWidget {
  const BookAppointmentBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: ElevatedButton(
        onPressed: () =>
            Navigator.pushNamed(context, CreateAppointmentScreen.routeName),
        style: ElevatedButton.styleFrom(
            backgroundColor: ThemeProvider.secondColor,
            shape: const StadiumBorder()),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Text(
            'Agendar Cita',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
              color: ThemeProvider.white,
            ),
          ),
        ),
      ),
    );
  }
}

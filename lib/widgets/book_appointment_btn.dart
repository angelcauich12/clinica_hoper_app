import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class BookAppointmentBtn extends StatelessWidget {
  final dynamic specialtyId;
  const BookAppointmentBtn({super.key, this.specialtyId});

  @override
  Widget build(BuildContext context) {
    final appointmentProv = Provider.of<AppointmentProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, CreateAppointmentScreen2.routeName);
          appointmentProv.specialtySelected = specialtyId;
          appointmentProv.doctors = [];
          final Specialty specialty = appointmentProv.specialties!.firstWhere((specialty) => specialty.id.toString() == appointmentProv.specialtySelected);
          appointmentProv.doctors = specialty.doctors!.toList();
        },
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

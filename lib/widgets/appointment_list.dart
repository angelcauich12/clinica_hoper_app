import 'package:flutter/material.dart';
import 'package:hope_app/models/appointments_response.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AppointmentList extends StatelessWidget {
  List<Appointment> appointments;

  AppointmentList({required this.appointments});

  @override
  Widget build(BuildContext context) {
    final appointmentProvider = Provider.of<AppointmentProvider>(context);

    Future<void> onRefresh() async {
      appointmentProvider.getAppointments();
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return AppointmentCard(appointment: appointments[index]);
        },
      ),
    );
  }
}

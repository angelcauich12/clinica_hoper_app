import 'package:flutter/material.dart';
import 'package:hope_app/models/appointments_response.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AppointmentList extends StatelessWidget {
  List<MyAppointment> appointments;

  AppointmentList({required this.appointments});

  @override
  Widget build(BuildContext context) {
    final appointmentProvider = Provider.of<AppointmentProvider>(context);

    Future<void> onRefresh() async {
      appointmentProvider.getAppointments();
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: (appointments.isNotEmpty)
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return AppointmentCard(appointment: appointments[index]);
              },
            )
          : Stack(
              children: [
                ListView(),
                const NoAppointmentsIcon(),
              ],
            ),
    );
  }
}

class NoAppointmentsIcon extends StatelessWidget {
  const NoAppointmentsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            color: ThemeProvider.lightGrey.withOpacity(0.3),
            size: 100,
          ),
          Text(
            'Sin Citas',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: ThemeProvider.lightGrey.withOpacity(0.3),
            ),
          )
        ],
      ),
    );
  }
}

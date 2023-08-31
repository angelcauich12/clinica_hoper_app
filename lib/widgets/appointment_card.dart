import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/appointments_response.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    final scheduleDate = DateFormat.yMMMEd('es-MX').format(
      DateTime.parse(appointment.scheduledDate),
    );
    final scheduledTime =
        Preferences.formatScheduledTime(appointment.scheduledTime);
    final scheduledTimeEnd =
        Preferences.formatScheduledTime(appointment.scheduledTimeEnd);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Preferences.isDarkMode
              ? ThemeProvider.secondColor
              : ThemeProvider.fourColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              spreadRadius: 2,
              offset: const Offset(-2, 2),
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AppointmentCardHeader(appointment: appointment),
          const SizedBox(height: 5),
          AppointmentCardBody(
            scheduleDate: scheduleDate,
            scheduledTime: scheduledTime,
            scheduledTimeEnd: scheduledTimeEnd,
            appointment: appointment,
          ),
        ],
      ),
    );
  }

  Future<String?> showCancelAppointment(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Cancelar Cita',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        content: Container(
          height: 100,
          child: Column(
            children: [
              const Text(
                '¿Está seguro que desea cancelar esta cita?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Form(
                  child: Column(
                children: [
                  TextFormField(),
                ],
              ))
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cerrar'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                ThemeProvider.lightRed,
              ),
            ),
            child: Text(
              'Cerrar',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: ThemeProvider.white,
              ),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                ThemeProvider.secondColor,
              ),
            ),
            onPressed: () => Navigator.pop(context, 'Confirmar'),
            child: Text(
              'Confirmar',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: ThemeProvider.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentCardHeader extends StatelessWidget {
  const AppointmentCardHeader({
    super.key,
    required this.appointment,
  });

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, DoctorScreen.routeName,
                  arguments: appointment),
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/medical-team.png'),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${appointment.doctor.name} ${appointment.doctor.lastName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Preferences.isDarkMode
                        ? ThemeProvider.white
                        : ThemeProvider.lightColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "${appointment.type} - ${appointment.specialty.name}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                    color: Preferences.isDarkMode
                        ? Colors.grey
                        : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Icon(Icons.more_vert, color: ThemeProvider.thirdColor),
        ),
      ],
    );
  }
}

class AppointmentCardBody extends StatelessWidget {
  const AppointmentCardBody({
    super.key,
    required this.scheduleDate,
    required this.scheduledTime,
    required this.scheduledTimeEnd,
    required this.appointment,
  });

  final String scheduleDate;
  final String scheduledTime;
  final String scheduledTimeEnd;
  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Preferences.isDarkMode
            ? Colors.grey.withOpacity(0.15)
            : ThemeProvider.secondColor.withAlpha(70),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppointmentDescription(
                description: scheduleDate,
                icon: Icons.calendar_month_outlined,
                color: ThemeProvider.lightColor,
              ),
              const SizedBox(height: 2),
              AppointmentDescription(
                description: '$scheduledTime - $scheduledTimeEnd',
                icon: Icons.timer_outlined,
                color: ThemeProvider.lightColor,
              ),
            ],
          ),
          const SizedBox(height: 2),
          AppointmentDescription(
            description:
                'Paciente: ${appointment.patient.name} ${appointment.patient.lastName}',
            icon: Icons.person_pin_outlined,
            color: ThemeProvider.lightColor,
          ),
        ],
      ),
    );
  }
}

class AppointmentDescription extends StatelessWidget {
  IconData icon;
  String description;
  Color color;

  AppointmentDescription(
      {required this.description, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Preferences.isDarkMode ? color : color,
        ),
        const SizedBox(width: 5),
        Text(
          description,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
            color: Preferences.isDarkMode ? color : color,
          ),
        ),
      ],
    );
  }
}

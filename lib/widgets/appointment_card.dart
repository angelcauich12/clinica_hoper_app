import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/appointments_response.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final scheduleDate =
        DateFormat.yMMMEd().format(DateTime.parse(appointment.scheduledDate));

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
          color: Preferences.isDarkMode
              ? ThemeProvider.brown
              : ThemeProvider.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              spreadRadius: 2,
              offset: const Offset(-2, 2),
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, DoctorScreen.routeName,
                        arguments: 'Dra. Nayli Hoil Pérez'),
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          AssetImage('assets/images/medical-team.png'),
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
                          fontSize: 20,
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: Preferences.isDarkMode
                              ? Colors.grey
                              : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => showCancelAppointment(context),
                child: const FaIcon(
                  FontAwesomeIcons.trashCan,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            height: 70,
            decoration: BoxDecoration(
              color: Preferences.isDarkMode
                  ? Colors.grey.withOpacity(0.15)
                  : Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  Icons.calendar_month,
                  color: Preferences.isDarkMode
                      ? Colors.white
                      : ThemeProvider.lightColor,
                ),
                Text(
                  scheduleDate,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Preferences.isDarkMode
                        ? Colors.white
                        : ThemeProvider.lightColor,
                  ),
                ),
                Icon(
                  Icons.timer_outlined,
                  color: Preferences.isDarkMode
                      ? Colors.white
                      : ThemeProvider.lightColor,
                ),
                Text(
                  "${appointment.scheduledTime} - ${appointment.scheduledTimeEnd}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Preferences.isDarkMode
                        ? Colors.white
                        : ThemeProvider.lightColor,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeProvider.green,
                ),
                child: const Row(
                  children: [
                    FaIcon(FontAwesomeIcons.thumbsUp),
                    // SizedBox(width: 5),
                    // Text(
                    //   'Confirmar',
                    //   style: TextStyle(fontWeight: FontWeight.w700),
                    // ),
                  ],
                ),
              ),
            ],
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

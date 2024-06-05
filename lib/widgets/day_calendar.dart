import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/theme_provider.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DayCalendar extends StatelessWidget {
  final  List<MyAppointment> appointments;
  const DayCalendar({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    final AppointmentDataSource appointmentDataSource = _getCalendarDataSource(appointments);
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.53,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: Text(
              'Citas Confirmadas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
                color: Preferences.isDarkMode
                    ? ThemeProvider.white
                    : ThemeProvider.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
              child: Container(
            margin: const EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            decoration: BoxDecoration(
              color: ThemeProvider.primaryColor.withAlpha(40),
              borderRadius: BorderRadius.circular(5),
            ),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: const Locale('es'),
              supportedLocales: const [
                Locale('es'),
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: SfCalendar(
                view: CalendarView.schedule,
                showDatePickerButton: true,
                minDate: DateTime.now(),
                dataSource: appointmentDataSource,
              ),
            ),
          ))
        ],
      ),
    );
  }

  AppointmentDataSource _getCalendarDataSource(
      List<MyAppointment> sourceAppointments) {
    List<Appointment> appointments = sourceAppointments.map((myAppointment) {
     
      DateTime? startTime = myAppointment.scheduledTime != null
          ? DateTime.parse(
              '${myAppointment.scheduledDate!} ${myAppointment.scheduledTime!}')
          : null;

      DateTime? endTime = myAppointment.scheduledTime != null
          ? DateTime.parse(
              '${myAppointment.scheduledDate!} ${myAppointment.scheduledTimeEnd!}')
          : null;

      return Appointment(
          id: myAppointment.id,
          startTime: startTime!,
          endTime: endTime!,
          notes: myAppointment.status!.name,
          color: ThemeProvider.blue,
          subject:
             'Px: ${myAppointment.patient!.name} ${myAppointment.patient!.lastName}');
    }).toList();

    return AppointmentDataSource(appointments);
  }
}

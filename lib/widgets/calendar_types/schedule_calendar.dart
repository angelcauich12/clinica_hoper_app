import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hope_app/models/models.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../utilities/general_functions.dart';

class ScheduleCalendar extends StatelessWidget {
  final  List<MyAppointment>? appointments;
  final bool? showDatePickerButton;
  const ScheduleCalendar({super.key, this.appointments, this.showDatePickerButton});

  @override
  Widget build(BuildContext context) {
    final AppointmentDataSource appointmentDataSource = GeneralFunctions.getCalendarDataSource(appointments ?? [], appointmenColor: Colors.blue, schedule: true);
    return MaterialApp(
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
                showDatePickerButton: showDatePickerButton ?? false,
                minDate: DateTime.now(),
                dataSource: appointmentDataSource,
              ),
            );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../models/models.dart';
import '../../utilities/general_functions.dart';

class WeekCanlendar extends StatelessWidget {
  final bool? showTodayButton;
  final int? numberOfDaysInView;
  final Duration? timeInterval;
  final bool? showCurrentTimeIndicator;
  final bool? showDatePickerButton;
  final List<TimeRegion>? specialRegions;
  final List<MyAppointment>? appointments;
  final bool? allowDragAndDrop; 
  final void Function(AppointmentDragEndDetails)? onDragEnd;
  final void Function(CalendarTapDetails)? onTap;
  final List<DateTime>? blackoutDates;
  final void Function(CalendarSelectionDetails)? onSelectionChanged;
  const WeekCanlendar(
      {super.key,
      this.showTodayButton = false,
      this.numberOfDaysInView,
      this.timeInterval,
      this.showCurrentTimeIndicator,
      this.showDatePickerButton,
      this.specialRegions,
      this.onTap,
      this.appointments, this.allowDragAndDrop, this.onDragEnd, this.blackoutDates, this.onSelectionChanged,});

  @override
  Widget build(BuildContext context) {
    final AppointmentDataSource appointmentDataSource = GeneralFunctions.getCalendarDataSource(appointments ?? []);
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
        onSelectionChanged: onSelectionChanged,
       allowAppointmentResize: true,
        showTodayButton: showTodayButton ?? false,
        showCurrentTimeIndicator: showCurrentTimeIndicator ?? false,
        showDatePickerButton: showDatePickerButton ?? false,
        allowDragAndDrop: allowDragAndDrop ?? false,
        specialRegions: specialRegions ?? [],
        onTap: onTap,
        onDragEnd: onDragEnd,
        blackoutDates: blackoutDates ?? [],
        dataSource: appointmentDataSource,
        todayHighlightColor: ThemeProvider.primaryColor,
        view: CalendarView.week,
        minDate: DateTime.now(),
        cellEndPadding: 0.0,
        headerStyle: CalendarHeaderStyle(
          backgroundColor: ThemeProvider.primaryColor,
          textStyle: const TextStyle(color: Colors.white),
        ),
        selectionDecoration: BoxDecoration(
          border: Border.all(
            color: ThemeProvider.primaryColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        timeSlotViewSettings: TimeSlotViewSettings(
          numberOfDaysInView: numberOfDaysInView ?? -1,
          timeInterval: timeInterval ?? const Duration(minutes: 60),
          timeFormat: 'h:mm a',
          timeTextStyle: const TextStyle(
            fontSize: 8,
          ),
        ),
        dragAndDropSettings: DragAndDropSettings(
            timeIndicatorStyle: TextStyle(color: ThemeProvider.primaryColor)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../providers/providers.dart';

class ManageScheduleScreen extends StatefulWidget {
  static const String routeName = 'manage-schedule';
  const ManageScheduleScreen({super.key});

  @override
  State<ManageScheduleScreen> createState() => _ManageScheduleScreenState();
}

class _ManageScheduleScreenState extends State<ManageScheduleScreen> {
  final List<TimeRegion> _selectedTimeRegions =
      []; // arreglo para las regiones seleccionadas
  DateTime? _selectedDate; //variable para la fecha
  DateTime? _intervalStartTime; // variable para la hora de inicio
  DateTime? _intervalEndTime; // variable para la hora final
  bool _isTappedDate = false; // variable para saber si se seleccionó el calendario o no

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 1,
            bottom: TabBar(
                unselectedLabelColor: Colors.grey,
                labelColor: ThemeProvider.white,
                indicator: const BoxDecoration(color: Colors.transparent),
                tabs: const [
                  Text(
                    'Calendario de exclusión',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      fontSize: 20,
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 10.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ],
                    ),
                  ),
                ]),
            centerTitle: true,
          ),
          body: TabBarView(
            children: [
              WeekCanlendar(
                showDatePickerButton: true,
                timeInterval: const Duration(minutes: 30),
                onTap: _onCalendarTapped,
                specialRegions: _selectedTimeRegions,
              )
            ],
          ),
          floatingActionButton: !_isTappedDate
              ? Container()
              : FloatingActionButtonsCalendar(
                  onPressedClose: () {
                    _isTappedDate = false;
                    _selectedTimeRegions.clear();
                    _selectedDate = null;
                    _intervalStartTime = null;
                    _intervalEndTime = null;
                    setState(() {});
                  },
                  onPressedSucess: () => {},
                )),
    );
  }

  void _onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    final DateTime tappedDate = calendarTapDetails.date!; //Fecha seleccionada
    if (calendarTapDetails.targetElement == CalendarElement.header ||
        calendarTapDetails.targetElement == CalendarElement.resourceHeader) {
      return;
    }

     if (calendarTapDetails.targetElement == CalendarElement.viewHeader) {
  final DateTime tappedDate = calendarTapDetails.date!;
  final DateTime startTime =
      DateTime(tappedDate.year, tappedDate.month, tappedDate.day, 0, 0);
  final DateTime endTime =
      DateTime(tappedDate.year, tappedDate.month, tappedDate.day, 23, 59);

  // Verificar si ya está seleccionado el día completo
  final bool isAlreadySelected = _selectedTimeRegions.any((region) =>
      region.startTime.isAtSameMomentAs(startTime) &&
      region.endTime.isAtSameMomentAs(endTime));

  if (isAlreadySelected) {
    return;
  }

  _isTappedDate = true;

  // Eliminar cualquier selección de horas individuales en el mismo día
  _selectedTimeRegions.removeWhere((region) =>
      region.startTime.year == startTime.year &&
      region.startTime.month == startTime.month &&
      region.startTime.day == startTime.day &&
      region.endTime.hour != 23 && region.endTime.minute != 59);

  // Pintar intervalos no seleccionados entre dos días
  if (_intervalStartTime != null && _intervalEndTime != null) {
    DateTime tempTime = _intervalEndTime!;
    while (tempTime.isBefore(startTime)) {
      final DateTime nextTime = tempTime.add(const Duration(minutes: 30));
      if (!_selectedTimeRegions.any((region) =>
          region.startTime.isAtSameMomentAs(tempTime) &&
          region.endTime.isAtSameMomentAs(nextTime)) && !_selectedTimeRegions.any((region) =>
              region.startTime.isAtSameMomentAs(DateTime(tempTime.year, tempTime.month, tempTime.day, 0, 0)) &&
              region.endTime.isAtSameMomentAs(DateTime(tempTime.year, tempTime.month, tempTime.day, 23, 59)))) {
        final TimeRegion fillRegion = TimeRegion(
          startTime: tempTime,
          endTime: nextTime,
          color: Colors.red.withOpacity(0.5),
        );
        _selectedTimeRegions.add(fillRegion);
      }
      tempTime = nextTime;
    }
  }

  // Pintar el día completo como región seleccionada
  final TimeRegion newRegion = TimeRegion(
    startTime: startTime,
    endTime: endTime,
    color: Colors.red.withOpacity(0.5),
  );

  _selectedTimeRegions.add(newRegion);
  setState(() {});

  if (_intervalStartTime == null || startTime.isBefore(_intervalStartTime!)) {
    _intervalStartTime = startTime;
  }
  if (_intervalEndTime == null || endTime.isAfter(_intervalEndTime!)) {
    _intervalEndTime = endTime;
  }

  // print('intervalo de inicio $_intervalStartTime');
  // print('intervalo de fin: $_intervalEndTime');
}
    //Tap en celda vacía
    if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      final DateTime startTime = tappedDate;
      final DateTime endTime = startTime.add(const Duration(minutes: 30));
      //Verificar si la sección ya está eligida
      final bool isAlreadySelected = _selectedTimeRegions.any((region) =>
          region.startTime.isAtSameMomentAs(startTime) &&
          region.endTime.isAtSameMomentAs(endTime));
      //verificar si la fecha ya está seleccionada como todo el día
      final bool isWithinFullDayRegion = _selectedTimeRegions.any((region) =>
          region.startTime.isAtSameMomentAs(
              DateTime(startTime.year, startTime.month, startTime.day, 0, 0)) &&
          region.endTime.isAtSameMomentAs(DateTime(
              startTime.year, startTime.month, startTime.day, 23, 59)));

      if (isAlreadySelected || isWithinFullDayRegion) {
        return;
      }

      _isTappedDate = true;

      // Pintar intervalos no seleccionados entre dos toques
      if (_intervalStartTime != null && _intervalEndTime != null) {
        DateTime earlierTime = _intervalStartTime!.isBefore(startTime)
            ? _intervalStartTime!
            : startTime;
        DateTime laterTime =
            _intervalEndTime!.isAfter(endTime) ? _intervalEndTime! : endTime;
        DateTime tempTime = earlierTime;
        while (tempTime.isBefore(laterTime)) {
          final DateTime nextTime = tempTime.add(const Duration(minutes: 30));
          if (!_selectedTimeRegions.any((region) =>
              region.startTime.isAtSameMomentAs(tempTime) &&
              region.endTime.isAtSameMomentAs(nextTime)) &&
          !_selectedTimeRegions.any((region) =>
              region.startTime.isAtSameMomentAs(DateTime(tempTime.year, tempTime.month, tempTime.day, 0, 0)) &&
              region.endTime.isAtSameMomentAs(DateTime(tempTime.year, tempTime.month, tempTime.day, 23, 59)))) {
            final TimeRegion fillRegion = TimeRegion(
              startTime: tempTime,
              endTime: nextTime,
              color: Colors.red.withOpacity(0.5),
            );
            _selectedTimeRegions.add(fillRegion);
          }
          tempTime = nextTime;
        }
      }

      // Verificar si los extremos ya están añadidos
      if (!_selectedTimeRegions.any((region) => region.startTime.isAtSameMomentAs(startTime) && region.endTime.isAtSameMomentAs(endTime))) {
        final TimeRegion newRegion = TimeRegion(
          startTime: startTime,
          endTime: endTime,
          color: Colors.red.withOpacity(0.5),
        );
        _selectedTimeRegions.add(newRegion);
      }

      setState(() {});

      //Fecha de inicio y fecha final de las regiones seleccionadas
      if (_intervalStartTime == null || startTime.isBefore(_intervalStartTime!)) {
        _intervalStartTime = startTime;
      }
      if (_intervalEndTime == null || endTime.isAfter(_intervalEndTime!)) {
        _intervalEndTime = endTime;
      }
      // print('intervalo de inicio $_intervalStartTime');
      // print('intervalo de fin: $_intervalEndTime');
    }

    //  else {
    //   if (calendarTapDetails.appointments != null && calendarTapDetails.targetElement == CalendarElement.appointment) {
    //     final Appointment appointment = calendarTapDetails.appointments!.first as Appointment;

    //     // Extraer el nombre del paciente del subject
    //     final RegExp regex = RegExp(r'Px: (.+)');
    //     final RegExpMatch? match = regex.firstMatch(appointment.subject);
    //     final String patientName =
    //         match != null ? match.group(1)! : 'Desconocido';

    //     final String startTime = formattedTime.format(appointment.startTime);
    //     final String endTime = formattedTime.format(appointment.endTime);
    //     final String date = DateFormat('EEEE, MMM dd, yyyy', 'es')
    //         .format(appointment.startTime);
    //     final String appointmentId = appointment.id.toString();
    //     final String status = appointment.notes.toString();

    //     GeneralFunctions.showDetails(patientName, date, startTime, endTime,
    //         appointmentId, status, context);
    //   }
    // }
  }
}

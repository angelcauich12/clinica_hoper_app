import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hope_app/utilities/general_functions.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../shared/preferences.dart';

class ManageScheduleScreen extends StatefulWidget {
  static const String routeName = 'manage-schedule';
  const ManageScheduleScreen({super.key});

  @override
  State<ManageScheduleScreen> createState() => _ManageScheduleScreenState();
}

class _ManageScheduleScreenState extends State<ManageScheduleScreen> {
  User apiUser = User.fromJson(Preferences.apiUser);
  final List<TimeRegion> _selectedTimeRegions =[]; // arreglo para las regiones seleccionadas
  DateTime? _intervalStartTime; // variable para la hora de inicio
  DateTime? _intervalEndTime; // variable para la hora final
  bool _isTappedDate = false; // variable para saber si se seleccionó el calendario o no

  @override
    initState()  {
    super.initState();
    final requestProvider = context.read<ManageScheduleProvider>();
     WidgetsBinding.instance.addPostFrameCallback((_) {
        requestProvider.doctorSelected =  apiUser.id.toString();
        requestProvider.getNonWorkingDays();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProv = Provider.of<ManageScheduleProvider>(context);
    final size = MediaQuery.of(context).size;
    final  nonWorkingDays = GeneralFunctions.getBlackoutDates(scheduleProv.nonWorkingDays) ;

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
          body: Stack(
            children: [
              TabBarView(
                children: [
                  WeekCanlendar(
                    showDatePickerButton: true,
                    timeInterval: const Duration(minutes: 30),
                    onTap: _onCalendarTapped,
                    specialRegions: _selectedTimeRegions,
                    appointments: nonWorkingDays,
                    showTodayButton: true,
                   
                  )
                ],
              ), scheduleProv.isLoading ? SizedBox(
                      width: size.width,
                      height: size.height * 0.6,
                      child: Center(
                        child: SpinKitCubeGrid(
                        color: ThemeProvider.secondColor,
                        ),
                      ),
              ): Container()
            ],
          ),
          floatingActionButton: !_isTappedDate
              ? Container()
              : FloatingActionButtonsCalendar(
                  onPressedClose: () {
                    _isTappedDate = false;
                    _selectedTimeRegions.clear();
                    _intervalStartTime = null;
                    _intervalEndTime = null;
                    setState(() {});
                  },
                  onPressedSucess: () async {
                  scheduleProv.initialTime = GeneralFunctions.formatTime('$_intervalStartTime',timeFormat:'HH:mm');
                  scheduleProv.endTime = GeneralFunctions.formatTime('$_intervalEndTime', timeFormat: 'HH:mm');
                  scheduleProv.initialDate = DateFormat('dd/MM/yyyy').format(_intervalStartTime!);
                  scheduleProv.endDate = DateFormat('dd/MM/yyyy').format(_intervalEndTime!);
                  final result = await scheduleProv.createNonWorkingDay();
                  if(result){
                    _isTappedDate = false;
                    _selectedTimeRegions.clear();
                    _intervalStartTime = null;
                    _intervalEndTime = null;
                    scheduleProv.initialTime = null;
                    scheduleProv.endTime = null;
                    scheduleProv.initialDate = null;
                    scheduleProv.endDate = null;
                  }
                 
                  },
                )),
    );
  }

  void _onCalendarTapped(CalendarTapDetails calendarTapDetails) {
  final DateTime tappedDate = calendarTapDetails.date!; //Fecha seleccionada
  if (calendarTapDetails.targetElement == CalendarElement.header || calendarTapDetails.targetElement == CalendarElement.resourceHeader) {
      return;
  }

  if (calendarTapDetails.targetElement == CalendarElement.viewHeader) {
  // final DateTime tappedDate = calendarTapDetails.date!;
  final DateTime startTime = DateTime(tappedDate.year, tappedDate.month, tappedDate.day, 0, 0);
  final DateTime endTime = DateTime(tappedDate.year, tappedDate.month, tappedDate.day, 23, 59);

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

  // Pintar días completos entre dos selecciones de días completos
  if (_intervalStartTime != null && _intervalEndTime != null) {
    DateTime earlierTime = _intervalStartTime!.isBefore(startTime)
        ? _intervalStartTime!
        : startTime;
    DateTime laterTime =
        _intervalEndTime!.isAfter(endTime) ? _intervalEndTime! : endTime;
    DateTime tempTime = earlierTime.add(const Duration(days: 1));

    while (tempTime.isBefore(laterTime)) {
      final DateTime nextDayStart = DateTime(tempTime.year, tempTime.month, tempTime.day, 0, 0);
      final DateTime nextDayEnd = DateTime(tempTime.year, tempTime.month, tempTime.day, 23, 59);
          final DateTime nextTime = tempTime.add(const Duration(minutes: 30));

      if (!_selectedTimeRegions.any((region) =>
          region.startTime.isAtSameMomentAs(tempTime) && region.endTime.isAtSameMomentAs(nextTime)) && !_selectedTimeRegions.any((region) =>
          region.startTime.isAtSameMomentAs(nextDayStart) &&
          region.endTime.isAtSameMomentAs(nextDayEnd))) {
        final TimeRegion fillRegion = TimeRegion(
          startTime: nextDayStart,
          endTime: nextDayEnd,
          color: Colors.red.withOpacity(0.5),
        );
        _selectedTimeRegions.add(fillRegion);
      }
      tempTime = tempTime.add(const Duration(days: 1));
    }
  }

  // Pintar intervalos no seleccionados entre hora individal y día completo
  if (_intervalStartTime != null && _intervalEndTime != null) {
    DateTime tempTime = _intervalEndTime!;
    while (tempTime.isBefore(startTime)) {
      final DateTime nextTime = tempTime.add(const Duration(minutes: 30));
      if (!_selectedTimeRegions.any((region) =>
          region.startTime.isAtSameMomentAs(tempTime) && region.endTime.isAtSameMomentAs(nextTime)) && 
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

  // Verificar si el nuevo segmento ya está seleccionado antes de añadirlo
  if (!_selectedTimeRegions.any((region) => region.startTime.isAtSameMomentAs(startTime) &&region.endTime.isAtSameMomentAs(endTime))) {
    final TimeRegion newRegion = TimeRegion(
      startTime: startTime,
      endTime: endTime,
      color: Colors.red.withOpacity(0.5),
    );

    _selectedTimeRegions.add(newRegion);
  }

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

     else {
      if (calendarTapDetails.appointments != null && calendarTapDetails.targetElement == CalendarElement.appointment) {
        final Appointment appointment = calendarTapDetails.appointments!.first as Appointment;
    
        final String startTime = DateFormat('h:mm a').format(appointment.startTime);
        final String endTime = DateFormat('h:mm a').format(appointment.endTime);
        final String date = DateFormat('dd-MM-yyyy', ).format(appointment.startTime);
        final String endDate =  DateFormat('dd-MM-yyyy', ).format(appointment.endTime);
        final String appointmentId = appointment.id.toString();
        GeneralFunctions.showDetails(
          date, startTime, endTime, appointmentId, context , endDate: endDate, head: 'Detalles del horario'
          );
      }
    }
  }
}

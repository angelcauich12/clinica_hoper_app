import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../providers/providers.dart';

import '../shared/preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class CreateAppointmentScreen2 extends StatefulWidget {
  static const String routeName = 'create-appointment2';
  const CreateAppointmentScreen2({super.key});

  @override
  State<CreateAppointmentScreen2> createState() =>
      _CreateAppointmentScreen2State();
}

class _CreateAppointmentScreen2State extends State<CreateAppointmentScreen2> {
  int _currentStep = 0;
  User apiUser = User.fromJson(Preferences.apiUser);
  final List<TimeRegion> _selectedTimeRegions = [];
  DateTime? _selectedDate;
  DateTime? _intervalStartTime;
  DateTime? _intervalEndTime;
  bool _isTappedDate = false;
  final DateFormat formattedDate = DateFormat('yyyy-MM-dd');
  final DateFormat formattedTime = DateFormat('h:mm a');

  @override
  void initState() {
    super.initState();
    if (apiUser.miPerfil.nombre == 'Doctor') {
      _currentStep = 2;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final appointmentRequestProvider = context.read<AppointmentProvider>();
        appointmentRequestProvider.doctorSelected = apiUser.id.toString();
        appointmentRequestProvider.workScheduleDoctor();
        appointmentRequestProvider.getAppointmentsCalendar();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointmentProv = Provider.of<AppointmentProvider>(context);
    final size = MediaQuery.of(context).size;
    final myColor = ThemeProvider.secondColor;
    final List<TimeRegion> disabledRegions = getDisabledRegions();
    final List<TimeRegion> enabledRegions =
        getTimeRegions(appointmentProv.workSchedule);
    final List<TimeRegion> specialRegions = [
      ...disabledRegions,
      ...enabledRegions,
      ..._selectedTimeRegions
    ];


    return Scaffold(
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          CustomAppBar(
              title: 'Agendar Cita',
              image: 'assets/images/modules/doctorappointment2.jpeg'),
          SliverList(
              delegate: SliverChildListDelegate([
            (appointmentProv.isLoadingCatalogs)
                ? SizedBox(
                    width: size.width,
                    height: size.height * 0.6,
                    child: Center(
                      child: SpinKitCubeGrid(
                        color: myColor,
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // color: Colors.blue
                    ),
                    width: size.width * 0.7,
                    height: size.height * 0.80,
                    child: Stack(
                      children: [
                        Stepper(
                          physics: const NeverScrollableScrollPhysics(),
                          connectorColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return myColor;
                            }
                            return Colors.grey;
                          }),
                          controlsBuilder:
                              (BuildContext context, ControlsDetails details) {
                            return _currentStep > 0
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      if (details.onStepCancel != null)
                                        _currentStep > 0 && _currentStep < 2
                                            ? ElevatedButton(
                                                onPressed: details.onStepCancel,
                                                child: Text(
                                                  'Anterior XD',
                                                  style:
                                                      TextStyle(color: myColor),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      if (details.onStepContinue != null)
                                        _currentStep > 4
                                            ? ElevatedButton(
                                                onPressed:
                                                    details.onStepContinue,
                                                child: Text('Continuar',
                                                    style: TextStyle(
                                                        color: myColor)),
                                              )
                                            : const SizedBox.shrink(),
                                    ],
                                  )
                                : const SizedBox.shrink();
                          },
                          type: StepperType.horizontal,
                          currentStep: _currentStep,
                          onStepCancel: () {
                            if (_currentStep > 0) {
                              setState(() {
                                _currentStep -= 1;
                              });
                            }
                          },
                          onStepContinue: () {
                            // si se agrega un Step se aumenta en uno el if
                            if (_currentStep <= 1) {
                              setState(() {
                                _currentStep += 1;
                              });
                            }
                          },
                          steps: <Step>[
                            Step(
                                isActive: _currentStep >= 0,
                                state: _currentStep > 0
                                    ? StepState.complete
                                    : StepState.indexed,
                                title: const Text(''),
                                label: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Especialidad',
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 9,
                                        color: _currentStep >= 0
                                            ? myColor
                                            : Colors.grey),
                                  ),
                                ),
                                content: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Especialidades',
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: myColor),
                                        ),
                                      ],
                                    ),
                                    (appointmentProv.specialties!.isNotEmpty)
                                        ? SizedBox(
                                            height: size.height * 0.45,
                                            //  color: Colors.green,
                                            child: ListView.builder(
                                                itemBuilder: (_, index) => Card(
                                                      child: ListTile(
                                                        trailing: const Icon(Icons
                                                            .navigate_next_rounded),
                                                        title: Text(
                                                            appointmentProv
                                                                    .specialties![
                                                                        index]
                                                                    .name ??
                                                                ''),
                                                        onTap: () {
                                                          setState(() {
                                                            apiUser.miPerfil
                                                                        .nombre !=
                                                                    'Doctor'
                                                                ? _currentStep +=
                                                                    1
                                                                : _currentStep +=
                                                                    2;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                itemCount:
                                                    apiUser.miPerfil.nombre !=
                                                            'Doctor'
                                                        ? appointmentProv
                                                                .specialties
                                                                ?.length ??
                                                            0
                                                        : apiUser.specialties
                                                                ?.length ??
                                                            0))
                                        : Container(),
                                    const SizedBox(
                                      height: 30,
                                    )
                                  ],
                                )),
                            Step(
                                isActive: _currentStep >= 1,
                                state: _currentStep > 1
                                    ? StepState.complete
                                    : StepState.indexed,
                                title: const Text(''),
                                label: Text(
                                  'Doctor',
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9,
                                      color: _currentStep >= 1
                                          ? myColor
                                          : Colors.grey),
                                ),
                                content: Container(
                                  color: Colors.yellow,
                                  child:
                                      const Text('Aquí van a ir los doctores'),
                                )),
                            Step(
                                isActive: _currentStep >= 2,
                                state: _currentStep > 2
                                    ? StepState.complete
                                    : StepState.indexed,
                                title: const Text(''),
                                label: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                    'Fecha y hora',
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 9,
                                        color: _currentStep >= 2
                                            ? myColor
                                            : Colors.grey),
                                  ),
                                ),
                                content: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.56,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: MaterialApp(
                                        debugShowCheckedModeBanner: false,
                                        locale: const Locale('es'),
                                        supportedLocales: const [
                                          Locale('es'),
                                          Locale('en'),
                                        ],
                                        localizationsDelegates: const [
                                          GlobalMaterialLocalizations.delegate,
                                          GlobalWidgetsLocalizations.delegate,
                                          GlobalCupertinoLocalizations.delegate,
                                        ],
                                        home: SfCalendar(
                                            view: CalendarView.week,
                                            timeSlotViewSettings:
                                                const TimeSlotViewSettings(
                                                    timeTextStyle: TextStyle(
                                                      fontSize: 8,
                                                    ),
                                                    numberOfDaysInView: 3,
                                                    timeInterval: Duration(
                                                      minutes: 30,
                                                    ),
                                                    timeFormat: 'h:mm a'),
                                            allowViewNavigation: true,
                                            showDatePickerButton: true,
                                            showNavigationArrow: true,
                                            headerStyle: CalendarHeaderStyle(
                                              backgroundColor: myColor,
                                              textStyle: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            todayHighlightColor: myColor,
                                            minDate: DateTime.now(),
                                            showCurrentTimeIndicator: false,
                                            selectionDecoration: BoxDecoration(
                                              border: Border.all(
                                                color: myColor,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(4)),
                                            ),
                                            specialRegions: specialRegions,
                                            dataSource: _getCalendarDataSource(
                                                appointmentProv
                                                    .calendarAppointments),
                                            cellEndPadding: 0.0,
                                            // allowDragAndDrop: true,
                                            appointmentTextStyle:
                                                const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white),
                                            onTap: _onCalendarTapped),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    apiUser.miPerfil.nombre != 'Doctor'
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              ElevatedButton(
                                                onPressed: apiUser
                                                            .miPerfil.nombre !=
                                                        'Doctor'
                                                    ? () {
                                                        setState(() {
                                                          _currentStep -= 1;
                                                        });
                                                      }
                                                    : () {
                                                        setState(() {
                                                          if (apiUser.specialties !=
                                                                  null &&
                                                              apiUser.specialties!
                                                                      .length >
                                                                  1) {
                                                            _currentStep -= 2;
                                                          }
                                                        });
                                                      },
                                                child: Text(
                                                  'Anterior =)',
                                                  style:
                                                      TextStyle(color: myColor),
                                                ),
                                              )
                                            ],
                                          )
                                        : Container(),
                                  ],
                                )),
                          ],
                        ),
                        Positioned(
                            bottom: 27,
                            right: 22,
                            child: !_isTappedDate || appointmentProv.isLoading
                                ? Container()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton.filled(
                                          style: TextButton.styleFrom(
                                              backgroundColor: myColor),
                                          onPressed: () {
                                            setState(() {
                                              _isTappedDate = false;
                                              _selectedTimeRegions.clear();
                                              _selectedDate = null;
                                              _intervalStartTime = null;
                                              _intervalEndTime = null;
                                              appointmentProv.startDate = null;
                                              appointmentProv.startDate = null;
                                              appointmentProv.endTime = null;
                                              appointmentProv
                                                  .specialtySelected = null;
                                              appointmentProv.doctorSelected = null;
                                            });
                                          },
                                          icon: const Icon(Icons.close)),
                                      IconButton.filled(
                                          style: TextButton.styleFrom(
                                              backgroundColor: myColor),
                                          onPressed: () {
                                            appointmentProv.doctorSelected = apiUser.id.toString();
                                            appointmentProv.startDate =
                                                formattedDate
                                                    .format(_selectedDate!);
                                            appointmentProv.startTime =
                                                formattedTime.format(
                                                    _intervalStartTime!);
                                            appointmentProv.endTime =
                                                formattedTime
                                                    .format(_intervalEndTime!);
                                            (apiUser.specialties != null &&
                                                    apiUser.specialties!
                                                            .length ==
                                                        1)
                                                ? appointmentProv
                                                        .specialtySelected =
                                                    apiUser
                                                        .specialties!.first.id
                                                        .toString()
                                                : appointmentProv
                                                        .specialtySelected =
                                                    appointmentProv
                                                        .specialtySelected
                                                        .toString();
                                            showModalBottomSheet(
                                              showDragHandle: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                              barrierColor: Colors.black26,
                                              context: context,
                                              builder: (context) {
                                                return const Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    FormCreateAppointment(),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon:
                                              const Icon(Icons.check_outlined)),
                                    ],
                                  )),
                        appointmentProv.isLoading
                            ? SizedBox(
                                width: size.width,
                                height: size.height * 0.6,
                                child: Center(
                                  child: SpinKitCubeGrid(
                                    color: myColor,
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  )
          ]))
        ],
      ),
    );
  }

  DateTime parseTimeString(String timeString) {
    final List<String> parts = timeString.split(':');
    final int hours = int.parse(parts[0]);
    final int minutes = int.parse(parts[1]);
    return DateTime(0, 0, 0, hours, minutes);
  }

// Funcion habilitar el horario del doctor
  List<TimeRegion> getTimeRegions(List<WorkScheduleDoctor> workSchedule) {
    final List<TimeRegion> regions = [];
    if (workSchedule.isNotEmpty) {
      for (var schedule in workSchedule) {
        final DateTime now = DateTime.now();
        final DateTime today = DateTime(now.year, now.month, now.day);

        // Obtiene los días de la semana como cadenas
        final daysOfWeek = schedule.daysOfWeek.map((day) {
          switch (day) {
            case 1:
              return 'MO';
            case 2:
              return 'TU';
            case 3:
              return 'WE';
            case 4:
              return 'TH';
            case 5:
              return 'FR';
            case 6:
              return 'SA';
            case 7:
              return 'SU';
            default:
              return '';
          }
        }).join(',');

        final DateTime startTime = parseTimeString(schedule.startTime);
        final DateTime endTime = parseTimeString(schedule.endTime);

        final TimeRegion region = TimeRegion(
          startTime: DateTime(today.year, today.month, today.day,
              startTime.hour, startTime.minute),
          endTime: DateTime(
              today.year, today.month, today.day, endTime.hour, endTime.minute),
          color: Colors.green.shade300.withOpacity(0.2),
          recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=$daysOfWeek',
        );
        regions.add(region);
      }
    }
    return regions;
  }

// Función para desabilitar todo el calendario
  List<TimeRegion> getDisabledRegions() {
    final List<TimeRegion> regions = [];
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    // Recurre semanalmente para cada día de la semana
    final List<String> daysOfWeek = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];

    for (String day in daysOfWeek) {
      regions.add(TimeRegion(
        startTime: DateTime(today.year, today.month, today.day, 0, 0),
        endTime: DateTime(today.year, today.month, today.day, 23, 59, 59),
        enablePointerInteraction: false,
        textStyle: const TextStyle(color: Colors.black45, fontSize: 15),
        color: Colors.grey.withOpacity(0.2),
        recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=$day',
      ));
    }

    return regions;
  }

  void _onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    /// Condition added to open the editor, when the calendar elements tapped
    /// other than the header.
    if (calendarTapDetails.targetElement == CalendarElement.header ||
        calendarTapDetails.targetElement == CalendarElement.resourceHeader) {
      return;
    }

    if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      _isTappedDate = true;
      final DateTime tappedDate = calendarTapDetails.date!;
      final DateTime selectedDate = DateTime(
        tappedDate.year,
        tappedDate.month,
        tappedDate.day,
      );

      if (_selectedDate == null) {
        _selectedDate = selectedDate;
      } else if (_selectedDate != selectedDate) {
        // ignorar la acción si la fecha no es la misma

        return;
      }

      final DateTime startTime = tappedDate;
      final DateTime endTime = startTime.add(const Duration(minutes: 30));

      final bool isAlreadySelected = _selectedTimeRegions.any((region) =>
          region.startTime.isAtSameMomentAs(startTime) &&
          region.endTime.isAtSameMomentAs(endTime));

      if (isAlreadySelected) {
        return;
      }

      // Verificar si es adyacente a alguna selección existente
      final bool isAdjacent = _selectedTimeRegions.any((region) =>
          region.endTime.isAtSameMomentAs(startTime) ||
          region.startTime.isAtSameMomentAs(endTime));

      if (_selectedTimeRegions.isNotEmpty && !isAdjacent) {
        return;
      }

      final TimeRegion newRegion = TimeRegion(
        startTime: startTime,
        endTime: endTime,
        color: Colors.blue.withOpacity(0.5),
      );

      setState(() {
        _selectedTimeRegions.add(newRegion);

        if (_intervalStartTime == null ||
            startTime.isBefore(_intervalStartTime!)) {
          _intervalStartTime = startTime;
        }
        if (_intervalEndTime == null || endTime.isAfter(_intervalEndTime!)) {
          _intervalEndTime = endTime;
        }
      });
    } else {
      if (calendarTapDetails.appointments != null &&
          calendarTapDetails.targetElement == CalendarElement.appointment) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              shape: Border(),
              title: Text(
                'Detalles de la cita',
                style: TextStyle(fontSize: 15),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Paciente:'),
                    ],
                  )
                ],
              ),
            );
          },
        );
      }
    }
  }
}

// Clase para crear las citas en el calendario
class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

_AppointmentDataSource _getCalendarDataSource(
    List<MyAppointment> sourceAppointments) {
  List<Appointment> appointments = sourceAppointments.map((myAppointment) {
    // Convertir la cadena de hora de inicio programada a un objeto DateTime
    DateTime? startTime = myAppointment.scheduledTime != null
        ? DateTime.parse(
            '${myAppointment.scheduledDate!} ${myAppointment.scheduledTime!}')
        : null;

    DateTime? endTime = myAppointment.scheduledTime != null
        ? DateTime.parse(
            '${myAppointment.scheduledDate!} ${myAppointment.scheduledTimeEnd!}')
        : null;

    // Dar formato a las horas en el formato 'hh:mm a'
    String formattedStartTime =
        startTime != null ? DateFormat('hh:mm ').format(startTime) : 'N/A';
    String formattedEndTime =
        endTime != null ? DateFormat('hh:mm ').format(endTime) : 'N/A';

    return Appointment(
        id: myAppointment.id,
        startTime: startTime!,
        endTime: endTime!,
        color: Colors.red,
        subject:
            '$formattedStartTime - $formattedEndTime\nPx: ${myAppointment.patient!.name} ${myAppointment.patient!.lastName}');
  }).toList();

  return _AppointmentDataSource(appointments);
}

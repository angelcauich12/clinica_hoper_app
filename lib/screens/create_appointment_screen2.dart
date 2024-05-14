import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../providers/providers.dart';
import '../search/patient_search_delegate.dart';
import '../shared/preferences.dart';
import '../ui/input_decorations.dart';
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
  final TextEditingController _searchController = TextEditingController();
  User apiUser = User.fromJson(Preferences.apiUser);

  @override
  void initState() {
    super.initState();
    if (apiUser.miPerfil.nombre == 'Doctor') {
      _currentStep = 2;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final appointmentRequestProvider = context.read<AppointmentProvider>();
        appointmentRequestProvider.doctorSelected = apiUser.id.toString();
        appointmentRequestProvider.workScheduleDoctor();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointmentProv = Provider.of<AppointmentProvider>(context);
    final size = MediaQuery.of(context).size;
    final appointmentForm = Provider.of<AppointmentProvider>(context);
    const myColor = Colors.lightBlue;

    DateTime parseTimeString(String timeString) {
      final List<String> parts = timeString.split(':');
      final int hours = int.parse(parts[0]);
      final int minutes = int.parse(parts[1]);
      return DateTime(0, 0, 0, hours, minutes);
    }

    List<TimeRegion> getTimeRegions() {
      final ap = Provider.of<AppointmentProvider>(context);
      final List<TimeRegion> regions = [];
      final DateTime now = DateTime.now();
      final DateTime today = DateTime(now.year, now.month, now.day);

      if (ap.workSchedule.isNotEmpty) {
        for (int i = 0; i < 50; i++) {
          final DateTime startOfWeek = today
              .subtract(Duration(days: today.weekday - 1))
              .add(Duration(days: 7 * i));
          startOfWeek.add(const Duration(days: 6));
          for (int j = 0; j < 7; j++) {
            final DateTime currentDay = startOfWeek.add(Duration(days: j));
            for (var schedule in appointmentProv.workSchedule) {
              if (schedule.daysOfWeek.contains(currentDay.weekday)) {
                final DateTime startTime = parseTimeString(schedule.startTime);
                final DateTime endTime = parseTimeString(schedule.endTime);

                final TimeRegion region = TimeRegion(
                  startTime: DateTime(currentDay.year, currentDay.month,
                      currentDay.day, startTime.hour, startTime.minute),
                  endTime: DateTime(currentDay.year, currentDay.month,
                      currentDay.day, endTime.hour, endTime.minute),
                  color: Colors.green.withOpacity(0.2),
                );
                regions.add(region);
              }
            }
          }
        }
      }
      return regions;
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomAppBar(
              title: 'Agendar Cita',
              image: 'assets/images/modules/doctorappointment2.jpeg'),
          SliverList(
              delegate: SliverChildListDelegate([
            (appointmentProv.isLoading)
                ? SizedBox(
                    width: size.width,
                    height: size.height * 0.6,
                    child: const Center(
                      child: SpinKitCubeGrid(
                        color: myColor,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        // color: Colors.blue
                      ),
                      width: size.width * 0.7,
                      height: size.height * 0.75,
                      child: Stepper(
                        physics: const ScrollPhysics(),
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
                                              child: const Text(
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
                                              onPressed: details.onStepContinue,
                                              child: const Text('Continuar',
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
                          if (_currentStep <= 2) {
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
                              label: Text(
                                'Especialidad',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9,
                                    color: _currentStep >= 0
                                        ? myColor
                                        : Colors.grey),
                              ),
                              content: Column(
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                child: const Text('Aquí van a ir los doctores'),
                              )),
                          Step(
                              isActive: _currentStep >= 2,
                              state: _currentStep > 2
                                  ? StepState.complete
                                  : StepState.indexed,
                              title: const Text(''),
                              label: Text(
                                'Fecha y hora',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9,
                                    color: _currentStep >= 2
                                        ? myColor
                                        : Colors.grey),
                              ),
                              content: Column(
                                children: [
                                  Container(
                                    height: size.height * 0.54,
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
                                        headerStyle: const CalendarHeaderStyle(
                                          backgroundColor: myColor,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                        ),
                                        todayHighlightColor: myColor,
                                        showCurrentTimeIndicator: false,
                                        selectionDecoration: BoxDecoration(
                                          border: Border.all(
                                            color: myColor,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4)),
                                        ),
                                        specialRegions: getTimeRegions(),
                                        dataSource: _getCalendarDataSource(
                                            appointmentProv.appointments),
                                        cellEndPadding: 0.0,
                                        // allowDragAndDrop: true,
                                        appointmentTextStyle: const TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      apiUser.miPerfil.nombre != 'Doctor'
                                          ? ElevatedButton(
                                              onPressed:
                                                  apiUser.miPerfil.nombre !=
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
                                              child: const Text(
                                                'Anterior =)',
                                                style:
                                                    TextStyle(color: myColor),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ],
                              )),
                          Step(
                              isActive: _currentStep >= 3,
                              state: _currentStep > 3
                                  ? StepState.complete
                                  : StepState.indexed,
                              title: const Text(''),
                              label: Text(
                                'Paciente',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9,
                                    color: _currentStep >= 3
                                        ? myColor
                                        : Colors.grey),
                              ),
                              content: Column(
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Paciente',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: myColor),
                                      ),
                                    ],
                                  ),
                                  TextFormField(
                                    readOnly: true,
                                    controller: _searchController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration:
                                        InputDecorations.authInputDecoration(
                                            color: myColor,
                                            hintText: 'John Doe',
                                            // labelText: 'Paciente',
                                            suffixIcon: Icons.search_outlined),
                                    onTap: () async {
                                      await showSearch(
                                        context: context,
                                        delegate: PatientSearchDelegate(),
                                      );
                                      if (appointmentProv.patientFullName !=
                                          '') {
                                        _searchController.text =
                                            appointmentProv.patientFullName;
                                      }
                                    },
                                    validator: (value) {
                                      return (value != null &&
                                              value.length >= 3)
                                          ? null
                                          : 'Paciente debe contener más de 3 caracteres.';
                                    },
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      ElevatedButton(
                                        onPressed:
                                            apiUser.miPerfil.nombre != 'Doctor'
                                                ? () {
                                                    setState(() {
                                                      _currentStep += 1;
                                                    });
                                                  }
                                                : () {
                                                    setState(() {
                                                      if (apiUser.specialties !=
                                                              null &&
                                                          apiUser.specialties!
                                                                  .length >
                                                              1) {
                                                        _currentStep += 1;
                                                      } else {
                                                        _currentStep += 3;
                                                      }
                                                    });
                                                  },
                                        child: const Text(
                                          'Continuar',
                                          style: TextStyle(color: myColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  )
          ]))
        ],
      ),
    );
  }
}

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
    String formattedStartTime = startTime != null
        ? DateFormat('hh:mm ').format(startTime)
        : 'N/A';
    String formattedEndTime = endTime != null
        ? DateFormat('hh:mm ').format(endTime)
        : 'N/A';

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

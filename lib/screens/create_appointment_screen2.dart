import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/widgets/appointment_status_label.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../providers/providers.dart';
import '../search/patient_search_delegate.dart';
import '../shared/preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../ui/input_decorations.dart';

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
  final myColor = ThemeProvider.secondColor;
  final TextEditingController _searchController = TextEditingController();
  int _numberOfDays = 3;
  bool _isEmergency = false;

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
    final List<TimeRegion> enabledRegions =
        getTimeRegions(appointmentProv.workSchedule);
    final List<TimeRegion> disabledRegions = getDisabledRegions(enabledRegions);
    final List<TimeRegion> specialRegions = [
      ...disabledRegions,
      ...enabledRegions,
      ..._selectedTimeRegions
    ];
    final AppointmentDataSource calendarAppointments =
        _getCalendarDataSource(appointmentProv.appointments);
    final appointmentForm = Provider.of<AppointmentProvider>(context);

    Future<void> onRefresh() async {
      appointmentProv.isLoading = true;
      await Future.delayed(const Duration(seconds: 2));
      appointmentProv.workScheduleDoctor();
      appointmentProv.getAppointments();
      appointmentProv.isLoading = false;
      setState(() {});
    }

    return Scaffold(
      body: RefreshIndicator(
        color: myColor,
        onRefresh: onRefresh,
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverAppBar(
                actions: [
                  PopupMenuButton<int>(
                    popUpAnimationStyle:
                        AnimationStyle(curve: Curves.easeInOutCirc),
                    elevation: 2,
                    surfaceTintColor: Colors.white,
                    icon: const Icon(
                      Icons.more_vert_outlined,
                      color: Colors.white,
                    ),
                    itemBuilder: (context) => <PopupMenuEntry<int>>[
                      const PopupMenuItem<int>(
                        height: 30,
                        value: 3,
                        child: Text(
                          'Días',
                          style: TextStyle(fontFamily: 'Roboto'),
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem<int>(
                        height: 30,
                        value: 7,
                        child: Text(
                          'Semana',
                          style: TextStyle(fontFamily: 'Roboto'),
                        ),
                      ),
                    ],
                    onSelected: (int result) {
                      setState(() {
                        _numberOfDays = result;
                      });
                    },
                  ),
                ],
                backgroundColor: myColor,
                floating: false,
                // pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.all(0),
                  title: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    alignment: Alignment.bottomCenter,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                    ),
                    child: const Text(
                      'Agendar Cita',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        shadows: [
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 10.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
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
                      width: size.width,
                      height: size.height,
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
                            controlsBuilder: (BuildContext context,
                                ControlsDetails details) {
                              return _currentStep > 0
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        if (details.onStepCancel != null)
                                          _currentStep > 0 && _currentStep < 2
                                              ? ElevatedButton(
                                                  onPressed:
                                                      details.onStepCancel,
                                                  child: Text(
                                                    'Anterior XD',
                                                    style: TextStyle(
                                                        color: myColor),
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
                            elevation: 10,
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
                                  content: Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
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
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        (appointmentProv
                                                .specialties!.isNotEmpty)
                                            ? ListView.builder(
                                                padding:
                                                    EdgeInsetsDirectional.zero,
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemBuilder: (_, index) =>
                                                    SizedBox(
                                                      height: 95,
                                                      child: Card(
                                                        elevation: 2,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            ListTile(    
                                                              trailing: CircleAvatar(
                                                                radius: 15,
                                                                backgroundColor: ThemeProvider.primaryColor,
                                                                child: const Icon(Icons.navigate_next_rounded, color: Colors.white,),),
                                                              title: Text(appointmentProv.specialties![index].name ?? '',
                                                                style: TextStyle(
                                                                  color: ThemeProvider
                                                                      .primaryColor,
                                                                  fontFamily:
                                                                      'Roboto',
                                
                                                                ),
                                                              ),
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
                                                          ],
                                                        ),
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
                                                            0)
                                            : Container(),
                                        const SizedBox(
                                          height: 30,
                                        )
                                      ],
                                    ),
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
                                    child: const Text(
                                        'Aquí van a ir los doctores'),
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
                                        height: size.height * 0.85,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                            bottom: BorderSide(
                                              color: myColor,
                                              width: 0.4,
                                            ),
                                          ),
                                        ),
                                        child: MaterialApp(
                                          debugShowCheckedModeBanner: false,
                                          locale: const Locale('es'),
                                          supportedLocales: const [
                                            Locale('es'),
                                          ],
                                          localizationsDelegates: const [
                                            GlobalMaterialLocalizations
                                                .delegate,
                                            GlobalWidgetsLocalizations.delegate,
                                            GlobalCupertinoLocalizations
                                                .delegate,
                                          ],
                                          home: SfCalendar(
                                            view: CalendarView.week,
                                            timeSlotViewSettings:
                                                TimeSlotViewSettings(
                                                    timeTextStyle:
                                                        const TextStyle(
                                                      fontSize: 8,
                                                    ),
                                                    numberOfDaysInView:
                                                        _numberOfDays,
                                                    timeInterval:
                                                        const Duration(
                                                      minutes: 30,
                                                    ),
                                                    timeFormat: 'h:mm a'),
                                            allowViewNavigation: true,
                                            showDatePickerButton: true,
                                            showNavigationArrow: false,
                                            showWeekNumber: true,
                                            headerStyle: CalendarHeaderStyle(
                                              backgroundColor: myColor,
                                              textStyle: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            todayHighlightColor: myColor,
                                            minDate: DateTime.now(),
                                            showCurrentTimeIndicator: true,
                                            showTodayButton: true,
                                            selectionDecoration: BoxDecoration(
                                              border: Border.all(
                                                color: myColor,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(4)),
                                            ),
                                            dragAndDropSettings:
                                                DragAndDropSettings(
                                                    timeIndicatorStyle:
                                                        TextStyle(
                                                            color: myColor)),
                                            cellEndPadding: 0.0,
                                            allowDragAndDrop: true,
                                            appointmentTextStyle:
                                                const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white),
                                            specialRegions: specialRegions,
                                            dataSource: calendarAppointments,
                                            onTap: _onCalendarTapped,
                                            // onDragStart: _onDragStart,
                                            onDragEnd: (details) =>
                                                _onDragEnd(details),
                                          ),
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
                                                  onPressed: apiUser.miPerfil
                                                              .nombre !=
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
                                                    style: TextStyle(
                                                        color: myColor),
                                                  ),
                                                )
                                              ],
                                            )
                                          : Container(),
                                    ],
                                  )),
                            ],
                          ),
                          _currentStep == 2
                              ? Positioned(
                                  top: 73,
                                  left: 175,
                                  right: 140,
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Emergencia',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            color: Colors.white,
                                            fontSize: 15),
                                      ),
                                      SizedBox(
                                        height: 25,
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: Switch.adaptive(
                                            inactiveTrackColor: Colors.grey,
                                            value: _isEmergency,
                                            onChanged: (bool value) {
                                              _isEmergency = value;
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                              : Container(),
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
                              : Container(),
                          !_isTappedDate
                              ? Container()
                              : Positioned(
                                  bottom: 150,
                                  right: 20,
                                  child: Row(
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
                                            });
                                          },
                                          icon: const Icon(Icons.close)),
                                      IconButton.filled(
                                          style: TextButton.styleFrom(
                                              backgroundColor: myColor),
                                          onPressed: () {
                                            appointmentProv.doctorSelected =
                                                apiUser.id.toString();
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
                                              isScrollControlled: true,
                                              showDragHandle: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                              barrierColor: Colors.black26,
                                              context: context,
                                              builder: (context) {
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SingleChildScrollView(
                                                      padding: EdgeInsets.only(
                                                          right: 15,
                                                          left: 15,
                                                          bottom: MediaQuery.of(
                                                                      context)
                                                                  .viewInsets
                                                                  .bottom +
                                                              60),
                                                      child: Form(
                                                        key: appointmentForm
                                                            .formKey,
                                                        child: Column(
                                                          children: [
                                                            TextFormField(
                                                              readOnly: true,
                                                              controller:
                                                                  _searchController,
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              decoration: InputDecorations
                                                                  .authInputDecoration(
                                                                      color:
                                                                          myColor,
                                                                      hintText:
                                                                          'Buscar paciente',
                                                                      // labelText: 'Paciente',
                                                                      suffixIcon:
                                                                          Icons
                                                                              .search_outlined),
                                                              onTap: () async {
                                                                await showSearch(
                                                                  context:
                                                                      context,
                                                                  delegate:
                                                                      PatientSearchDelegate(),
                                                                );
                                                                if (appointmentProv
                                                                        .patientFullName !=
                                                                    '') {
                                                                  _searchController
                                                                          .text =
                                                                      appointmentProv
                                                                          .patientFullName;
                                                                }
                                                              },
                                                              validator:
                                                                  (value) {
                                                                //  if (value != null)  _handleTextChanged();
                                                                return (value !=
                                                                            null &&
                                                                        value.length >=
                                                                            3)
                                                                    ? null
                                                                    : 'Paciente debe contener más de 3 caracteres.';
                                                              },
                                                            ),
                                                            const SizedBox(
                                                                height: 15),
                                                            TextFormField(
                                                              minLines: 1,
                                                              maxLines: 2,
                                                              initialValue:
                                                                  'Consulta',
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              decoration: InputDecoration(
                                                                  focusedBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          color:
                                                                              myColor)),
                                                                  counterText:
                                                                      '',
                                                                  border:
                                                                      const OutlineInputBorder(),
                                                                  hintText:
                                                                      'Describa brevemente la razón de la cita',
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          350],
                                                                      fontSize:
                                                                          14),
                                                                  labelText:
                                                                      'Descripción',
                                                                  labelStyle:
                                                                      TextStyle(
                                                                          color:
                                                                              myColor)),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .multiline,
                                                              maxLength: 40,
                                                              onChanged: (value) =>
                                                                  appointmentProv
                                                                          .description =
                                                                      value,
                                                              validator:
                                                                  (value) {
                                                                return (value !=
                                                                            null &&
                                                                        value.length >=
                                                                            3)
                                                                    ? null
                                                                    : 'La descripción debe contener más de 3 caracteres.';
                                                              },
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: ElevatedButton(
                                                                      style: TextButton.styleFrom(
                                                                        backgroundColor:
                                                                            myColor,
                                                                      ),
                                                                      onPressed: () async {
                                                                        if (!appointmentProv
                                                                            .isValidForm())
                                                                          return;
                                                                        FocusScope.of(context)
                                                                            .unfocus();
                                                                        Navigator.pop(
                                                                            context);
                                                                        _isTappedDate =
                                                                            false;
                                                                        _selectedTimeRegions
                                                                            .clear();
                                                                        appointmentProv.isLoading =
                                                                            true;
                                                                        await Future.delayed(const Duration(
                                                                            seconds:
                                                                                1));
                                                                        final result =
                                                                            await appointmentProv.createAppointment();
                                                                        if (result) {
                                                                          appointmentProv.patientSelected =
                                                                              null;
                                                                          appointmentProv.startDate =
                                                                              null;
                                                                          appointmentForm.endTime =
                                                                              null;
                                                                          appointmentProv.startTime =
                                                                              null;
                                                                          appointmentProv.doctorSelected =
                                                                              null;
                                                                          _searchController
                                                                              .clear();
                                                                        }
                                                                      },
                                                                      child: const Text(
                                                                        'Agendar Cita',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon:
                                              const Icon(Icons.check_outlined)),
                                    ],
                                  ),
                                )
                        ],
                      ),
                    )
            ]))
          ],
        ),
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
          enablePointerInteraction: true,
          recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=$daysOfWeek',
        );

        // Evita duplicados antes de añadir la región
        if (!regions.any((existingRegion) =>
            existingRegion.startTime == region.startTime &&
            existingRegion.endTime == region.endTime &&
            existingRegion.recurrenceRule == region.recurrenceRule)) {
          regions.add(region);
        }
      }
    }
    return regions;
  }

// Función para desabilitar todo el calendario
  List<TimeRegion> getDisabledRegions(List<TimeRegion> enabledRegions) {
    final List<TimeRegion> regions = [];
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    final List<String> daysOfWeek = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];

    for (String day in daysOfWeek) {
      // print('Day: $day'); // Debugging line
      final List<TimeRegion> dayEnabledRegions = enabledRegions
          .where((region) => region.recurrenceRule!.contains(day))
          .toList();

      // print('Day Enabled Regions: ${dayEnabledRegions.length} items'); // Debugging line
      // for (var region in dayEnabledRegions) {
      //   print('Enabled Region: ${region.startTime} - ${region.endTime}'); // Debugging line
      // }
      DateTime dayStartTime =
          DateTime(today.year, today.month, today.day, 0, 0);
      DateTime dayEndTime =
          DateTime(today.year, today.month, today.day, 23, 59, 59);

      // Ordenar las regiones habilitadas por hora de inicio
      dayEnabledRegions.sort((a, b) => a.startTime.compareTo(b.startTime));

      DateTime previousEndTime = dayStartTime;

      for (var region in dayEnabledRegions) {
        if (region.startTime.isAfter(previousEndTime)) {
          _isEmergency
              ? regions.add(TimeRegion(
                  startTime: previousEndTime,
                  endTime: region.startTime,
                  enablePointerInteraction: true,
                  textStyle:
                      const TextStyle(color: Colors.black45, fontSize: 15),
                  color: Colors.green.shade300.withOpacity(0.2),
                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=$day',
                ))
              : regions.add(TimeRegion(
                  startTime: previousEndTime,
                  endTime: region.startTime,
                  enablePointerInteraction: false,
                  textStyle:
                      const TextStyle(color: Colors.black45, fontSize: 15),
                  color: Colors.grey.withOpacity(0.2),
                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=$day',
                ));
          // print('Disabled Region: $previousEndTime - ${region.startTime}'); // Debugging line
        }
        previousEndTime = region.endTime;
      }

      if (previousEndTime.isBefore(dayEndTime)) {
        _isEmergency
            ? regions.add(TimeRegion(
                startTime: previousEndTime,
                endTime: dayEndTime,
                enablePointerInteraction: true,
                textStyle: const TextStyle(color: Colors.black45, fontSize: 15),
                color: Colors.green.shade300.withOpacity(0.2),
                recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=$day',
              ))
            : regions.add(TimeRegion(
                startTime: previousEndTime,
                endTime: dayEndTime,
                enablePointerInteraction: false,
                textStyle: const TextStyle(color: Colors.black45, fontSize: 15),
                color: Colors.grey.withOpacity(0.2),
                recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=$day',
              ));
        // print('Disabled Region: $previousEndTime - $dayEndTime'); // Debugging line
      }
    }

    return regions;
  }

  void _onCalendarTapped(CalendarTapDetails calendarTapDetails) {
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
        print(calendarTapDetails.appointments!.first);
        final Appointment appointment =
            calendarTapDetails.appointments!.first as Appointment;

        // Extraer el nombre del paciente del subject
        final RegExp regex = RegExp(r'Px: (.+)');
        final RegExpMatch? match = regex.firstMatch(appointment.subject);
        final String patientName =
            match != null ? match.group(1)! : 'Desconocido';

        final String startTime = formattedTime.format(appointment.startTime);
        final String endTime = formattedTime.format(appointment.endTime);
        final String date = DateFormat('EEEE, MMM dd, yyyy', 'es')
            .format(appointment.startTime);
        final String appointmentId = appointment.id.toString();
        final String status = appointment.notes.toString();

        _showDetails(
            patientName, date, startTime, endTime, appointmentId, status);
      }
    }
  }

  Future<void> _showDetails(String patientName, String date, String startTime,
      String endTime, String id, String status) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          contentPadding: const EdgeInsetsDirectional.symmetric(
              horizontal: 10.0, vertical: 3.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showCancelAppointment(context, id);
                      },
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red.shade800,
                      )),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        color: myColor,
                      ))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detalles de la cita',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: myColor),
                  ),
                  StatusLabel(
                    status: status,
                  )
                ],
              ),
              const SizedBox(
                height: 12.0,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.person_pin_outlined),
                        const Text(
                          'Paciente:',
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            patientName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                        ),
                        Text(
                          date,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.timer_outlined),
                        Text('$startTime - $endTime')
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> showCancelAppointment(BuildContext context, String id) {
    final cancelForm =
        Provider.of<CancelAppointmentFormProvider>(context, listen: false);
    final appointmentProv =
        Provider.of<AppointmentProvider>(context, listen: false);

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        title: const Text(
          'Cancelar Cita',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '¿Realmente desea cancelar esta cita?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            Form(
                key: cancelForm.formKey,
                child: Column(
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      decoration: InputDecorations.authInputDecoration(
                        color: Colors.grey[350]!,
                        hintText: 'Motivo de Cancelación',
                        labelText: 'Justificación',
                      ),
                      onChanged: (value) => cancelForm.justification = value,
                      validator: (value) {
                        return (value != null && value.length >= 3)
                            ? null
                            : 'Escriba una justificación para cancelar';
                      },
                    ),
                  ],
                ))
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cerrar'),
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              backgroundColor: ThemeProvider.lightRed,
            ),
            child: Text(
              'Cerrar',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                color: ThemeProvider.white,
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                backgroundColor: ThemeProvider.secondColor),
            onPressed: () {
              if (!cancelForm.isValidForm()) return;
              Navigator.pop(context);
              appointmentProv.cancelAppointment(id, cancelForm.justification);
            },
            child: Text(
              'Confirmar',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                color: ThemeProvider.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppointmentDataSource _getCalendarDataSource(
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
          notes: myAppointment.status!.name,
          color: Colors.red,
          subject:
              '$formattedStartTime - $formattedEndTime\nPx: ${myAppointment.patient!.name} ${myAppointment.patient!.lastName}');
    }).toList();

    return AppointmentDataSource(appointments);
  }

  void _onDragEnd(
    AppointmentDragEndDetails appointmentDragEndDetails,
  ) {
    final appointmentProv =
        Provider.of<AppointmentProvider>(context, listen: false);
    Appointment detail = appointmentDragEndDetails.appointment as Appointment;
    Duration duration = detail.endTime.difference(detail.startTime);

    DateTime droppingTime = appointmentDragEndDetails.droppingTime!;

    int minute = droppingTime.minute;
    if (minute < 15) {
      minute = 0;
    } else if (minute < 45) {
      minute = 30;
    } else {
      minute = 0;
      droppingTime = droppingTime.add(const Duration(hours: 1));
    }

    DateTime start = DateTime(
      droppingTime.year,
      droppingTime.month,
      droppingTime.day,
      droppingTime.hour,
      minute,
      0, // Segundos a 0
    );

    DateTime end = start.add(duration);

    // Actualiza la cita con los nuevos tiempos ajustados
    detail = Appointment(
        startTime: start,
        endTime: end,
        subject: detail.subject,
        color: detail.color,
        id: detail.id);

    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        title: const Text(
          'Modificar cita',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '¿Realmente desea cambiar la fecha y hora de esta cita?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => setState(() {
              Navigator.pop(context, 'Cerrar');
            }),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                ThemeProvider.lightRed,
              ),
            ),
            child: Text(
              'Cerrar',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
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
            onPressed: () async {
              Navigator.pop(context);
              await appointmentProv.updateAppointment(
                  detail.id.toString(),
                  formattedDate.format(detail.startTime),
                  formattedTime.format(detail.startTime),
                  formattedTime.format(detail.endTime));
            },
            child: Text(
              'Confirmar',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                color: ThemeProvider.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Clase para crear las citas en el calendario


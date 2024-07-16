import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/utilities/general_functions.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../providers/providers.dart';
import '../search/patient_search_delegate.dart';
import '../shared/preferences.dart';
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
  final List<TimeRegion> _selectedTimeRegions = []; // arreglo para las regiones seleccionadas
  DateTime? _selectedDate; //variable para la fecha 
  DateTime? _intervalStartTime; // variable para la hora de inicio
  DateTime? _intervalEndTime; // variable para la hora final
  bool _isTappedDate = false; // variable para saber si se seleccionó el calendario o no
  final DateFormat formattedDate = DateFormat('yyyy-MM-dd');
  final DateFormat formattedTime = DateFormat('h:mm a');
  final myColor = ThemeProvider.secondColor;
  final TextEditingController _searchController = TextEditingController();
  int _numberOfDays = 3;
  bool _isEmergency = false;
  

  @override
  void initState() {
    super.initState();
    final appointmentRequestProvider = context.read<AppointmentProvider>();
   
    if (apiUser.miPerfil.nombre == 'Doctor' &&
        apiUser.specialties != null &&
        apiUser.specialties!.length == 1) {
      _currentStep = 2;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        appointmentRequestProvider.doctorSelected = apiUser.id.toString();
        appointmentRequestProvider.getNonWorkingDays();
        // appointmentRequestProvider.workScheduleDoctor();
      });
    }

    if (appointmentRequestProvider.specialtySelected != null &&
        apiUser.miPerfil.nombre != 'Doctor') {
      _currentStep = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointmentProv = Provider.of<AppointmentProvider>(context);
    final size = MediaQuery.of(context).size;
   
    final List<TimeRegion> enabledRegions = GeneralFunctions.getWorkScheduleRegions(appointmentProv.workSchedule);
    final desabledRegions = getDisabledRegions(enabledRegions);
    final List<TimeRegion>  nonWorkingDays = GeneralFunctions.getNonWorkingDays(appointmentProv.nonWorkingDays);
   List<TimeRegion> specialRegions = [
      ..._selectedTimeRegions,
      ...desabledRegions,
      ...enabledRegions,
      ...nonWorkingDays,
    ];

    final calendarAppointments = GeneralFunctions.getCalendarDataSource( appointmentProv.appointments);
    final doctorAppointments =  GeneralFunctions.getCalendarDataSource(appointmentProv.doctorAppointments);
    final appointmentForm = Provider.of<AppointmentProvider>(context);

    Future<void> onRefresh() async {
      appointmentProv.isLoading = true;
      await Future.delayed(const Duration(seconds: 2));
      switch (_currentStep) {
        case 0:
          appointmentProv.getData();
          break;
        case 1:
          appointmentProv.getData();
          break;
        case 2:
          appointmentProv.workScheduleDoctor();
          appointmentProv.getAppointments();
          break;
        default:
          appointmentProv.getData();
      }
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
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          if (details.onStepCancel != null)
                                            _currentStep > 0 && _currentStep < 2
                                                ? ElevatedButton(
                                                    onPressed:
                                                        details.onStepCancel,
                                                    child: Text(
                                                      'Anterior',
                                                      style: TextStyle(
                                                          color: Preferences
                                                                  .isDarkMode
                                                              ? ThemeProvider
                                                                  .white
                                                              : myColor),
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                        ],
                                      ),
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
                                            ? Preferences.isDarkMode
                                                ? ThemeProvider.white
                                                : myColor
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
                                                  color: Preferences.isDarkMode
                                                      ? ThemeProvider.white
                                                      : myColor),
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
                                                itemBuilder:
                                                    (_, index) => SizedBox(
                                                          height: 70,
                                                          child: Card(
                                                            elevation: 2,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                ListTile(
                                                                  trailing:
                                                                      CircleAvatar(
                                                                    radius: 15,
                                                                    backgroundColor:
                                                                        ThemeProvider
                                                                            .primaryColor,
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .navigate_next_rounded,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  title: Text(
                                                                    appointmentProv
                                                                            .specialties![index]
                                                                            .name ??
                                                                        '',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Preferences.isDarkMode
                                                                          ? ThemeProvider
                                                                              .white
                                                                          : ThemeProvider
                                                                              .primaryColor,
                                                                      fontFamily:
                                                                          'Roboto',
                                                                    ),
                                                                  ),
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      apiUser.miPerfil.nombre !=
                                                                              'Doctor'
                                                                          ? _currentStep +=
                                                                              1
                                                                          : _currentStep +=
                                                                              2;
                                                                      appointmentProv.specialtySelected = appointmentProv
                                                                          .specialties![
                                                                              index]
                                                                          .id
                                                                          .toString();
                                                                      appointmentProv
                                                                          .doctors = [];
                                                                      final Specialty
                                                                          specialty =
                                                                          appointmentProv.specialties!.firstWhere((specialty) =>
                                                                              specialty.id.toString() ==
                                                                              appointmentProv.specialtySelected);
                                                                      appointmentProv
                                                                              .doctors =
                                                                          specialty
                                                                              .doctors!
                                                                              .toList();
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
                                            ? Preferences.isDarkMode
                                                ? ThemeProvider.white
                                                : myColor
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
                                              'Doctores',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Preferences.isDarkMode
                                                      ? ThemeProvider.white
                                                      : myColor),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        (appointmentProv.doctors!.isNotEmpty)
                                            ? ListView.builder(
                                                padding:
                                                    EdgeInsetsDirectional.zero,
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemBuilder:
                                                    (_, index) => SizedBox(
                                                          height: 70,
                                                          child: Card(
                                                            elevation: 2,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                ListTile(
                                                                  leading:
                                                                      const CircleAvatar(
                                                                    radius: 20,
                                                                    backgroundImage:
                                                                        AssetImage(
                                                                            'assets/images/medical-team.png'),
                                                                  ),
                                                                  trailing:
                                                                      CircleAvatar(
                                                                    radius: 15,
                                                                    backgroundColor:
                                                                        ThemeProvider
                                                                            .primaryColor,
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .navigate_next_rounded,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  title: Text(
                                                                    appointmentProv
                                                                            .doctors![index]
                                                                            .name ??
                                                                        '',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Preferences.isDarkMode
                                                                          ? ThemeProvider
                                                                              .white
                                                                          : ThemeProvider
                                                                              .primaryColor,
                                                                      fontFamily:
                                                                          'Roboto',
                                                                    ),
                                                                  ),
                                                                  onTap:
                                                                      () async {
                                                                    setState(
                                                                        () {
                                                                      _currentStep +=
                                                                          1;
                                                                    });

                                                                    appointmentProv
                                                                            .doctorSelected =
                                                                        appointmentProv
                                                                            .doctors![index]
                                                                            .id
                                                                            .toString();

                                                                    appointmentProv
                                                                            .isLoading =
                                                                        true;
                                                                    appointmentProv
                                                                        .workSchedule = [];
                                                                    await appointmentProv
                                                                        .workScheduleDoctor();
                                                                    await appointmentProv
                                                                        .getDoctorAppointments();
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
                                                                .doctors
                                                                ?.length ??
                                                            0
                                                        : apiUser.specialties
                                                                ?.length ??
                                                            0)
                                            : const EmptyContainer(
                                                text: 'Sin doctores'),
                                        const SizedBox(
                                          height: 30,
                                        )
                                      ],
                                    ),
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
                                            ? Preferences.isDarkMode
                                                ? ThemeProvider.white
                                                : myColor
                                            : Colors.grey),
                                  ),
                                  content: Column(
                                    children: [
                                      Container(
                                          height: size.height * 0.85,
                                          decoration: BoxDecoration(
                                            // color: Colors.red,
                                            border: Border(
                                              bottom: BorderSide(
                                                color: myColor,
                                                width: 0.4,
                                              ),
                                            ),
                                          ),
                                          child: WeekCanlendar(
                                              timeInterval:  const Duration(minutes: 30),
                                              allowDragAndDrop: apiUser.miPerfil.nombre != 'Doctor' ? false :  true,
                                              specialRegions: specialRegions,
                                              appointments: apiUser.miPerfil.nombre != 'Doctor' ? doctorAppointments : calendarAppointments,
                                              onTap: apiUser.miPerfil.nombre != 'Doctor' ? null : _onCalendarTapped,
                                              onDragEnd: (details) => _onDragEnd(details),
                                              numberOfDaysInView: _numberOfDays,
                                              showTodayButton: true,
                                              )),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      apiUser.miPerfil.nombre != 'Doctor'
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 25),
                                              child: Row(
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
                                                                _currentStep -=
                                                                    2;
                                                              }
                                                            });
                                                          },
                                                    child: Text(
                                                      'Anterior',
                                                      style: TextStyle(
                                                          color: Preferences
                                                                  .isDarkMode
                                                              ? ThemeProvider
                                                                  .white
                                                              : myColor),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  )),
                            ],
                          ),
                          apiUser.miPerfil.nombre == 'Doctor'
                              ? _currentStep == 2
                                  ? Positioned(
                                      top: 73,
                                      left: 160,
                                      // right: 120,
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
                                                activeColor: Colors.blue,
                                                activeTrackColor: Colors.blue,
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
                                  : Container()
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
                          apiUser.miPerfil.nombre != 'Doctor' &&
                                  _currentStep == 2
                              ? const Positioned(
                                  bottom: 150, right: 20, child: FloatingMenu())
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
                                            appointmentProv.doctorSelected = apiUser.id.toString();
                                            appointmentProv.startDate = formattedDate.format(_selectedDate!);
                                            appointmentProv.startTime =formattedTime.format(_intervalStartTime!);
                                            appointmentProv.endTime = formattedTime.format(_intervalEndTime!);
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
                                                                  labelStyle: TextStyle(
                                                                      color: Preferences
                                                                              .isDarkMode
                                                                          ? ThemeProvider
                                                                              .white
                                                                          : myColor)),
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


  void _onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.header ||
        calendarTapDetails.targetElement == CalendarElement.resourceHeader) {
      return;
    }

    if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
    
      final DateTime tappedDate = calendarTapDetails.date!;
      final DateTime selectedDate = DateTime(tappedDate.year,tappedDate.month,tappedDate.day,
      );

      if (_selectedDate == null) {
        _selectedDate = selectedDate;
      } else if (_selectedDate != selectedDate) {
        // ignorar la acción si la fecha no es la misma
        return;
      }

      final DateTime startTime = tappedDate;
      final DateTime endTime = startTime.add(const Duration(minutes: 30));

      final bool isAlreadySelected = _selectedTimeRegions.any((region) =>region.startTime.isAtSameMomentAs(startTime) && region.endTime.isAtSameMomentAs(endTime));

      if (isAlreadySelected) {
        return;
      }
       _isTappedDate = true;

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

        if (_intervalStartTime == null || startTime.isBefore(_intervalStartTime!)) {
          _intervalStartTime = startTime;
        }
        if (_intervalEndTime == null || endTime.isAfter(_intervalEndTime!)) {
          _intervalEndTime = endTime;
        }

      });
    } else {
      if (calendarTapDetails.appointments != null && calendarTapDetails.targetElement == CalendarElement.appointment) {
        final Appointment appointment = calendarTapDetails.appointments!.first as Appointment;

        // Extraer el nombre del paciente del subject
        final RegExp regex = RegExp(r'Px: (.+)');
        final RegExpMatch? match = regex.firstMatch(appointment.subject);
        final String patientName = match != null ? match.group(1)! : 'Desconocido';

        final String startTime = formattedTime.format(appointment.startTime);
        final String endTime = formattedTime.format(appointment.endTime);
        final String date = DateFormat('EEEE, MMM dd, yyyy', 'es')
            .format(appointment.startTime);
        final String appointmentId = appointment.id.toString();
        final String status = appointment.notes.toString();

        GeneralFunctions.showDetails(
          date,startTime, endTime, appointmentId,context, patientName: patientName, 
          status: status, isAppointment: true,
          head: 'Detalles de la cita'
          );
      }
    }
  }


  void _onDragEnd(AppointmentDragEndDetails appointmentDragEndDetails) {

    final appointmentProv = Provider.of<AppointmentProvider>(context, listen: false);
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


 List<TimeRegion> getDisabledRegions(List<TimeRegion> enabledRegions) {
    final List<TimeRegion> disabledRegions = [];
    DateTime now = DateTime.now();
    List<int> enabledDaysOfWeek = [];

    for (var region in enabledRegions) {
      // Obtener los días permitidos de las regiones habilitadas
      if (region.recurrenceRule != null) {
        String days = region.recurrenceRule!.split('BYDAY=')[1].split(';')[0];
        enabledDaysOfWeek.addAll(days.split(',').map((day) {
          switch (day) {
            case 'MO': return 1;
            case 'TU': return 2;
            case 'WE': return 3;
            case 'TH': return 4;
            case 'FR': return 5;
            case 'SA': return 6;
            case 'SU': return 0;
            default: return -1;
          }
        }));
      }
    }

    // Deshabilitar todas las horas para los días que no están permitidos
    for (int day = 0; day < 7; day++) {
      if (!enabledDaysOfWeek.contains(day)) {
        for (int hour = 0; hour < 24; hour++) {
          disabledRegions.add(TimeRegion(
            startTime: DateTime(now.year, now.month, now.day + (day - now.weekday + 7) % 7, hour, 0),
            endTime: DateTime(now.year, now.month, now.day + (day - now.weekday + 7) % 7, hour + 1, 0),
            color:  _isEmergency ? Colors.green.shade100 :Colors.grey.shade200,
            enablePointerInteraction: _isEmergency ? true : false,
            recurrenceRule: 'FREQ=WEEKLY;BYDAY=${GeneralFunctions.dayToWeekDay(day)};INTERVAL=1',
          ));
        }
      }
    }

    // Deshabilitar las horas no permitidas en los días habilitados
    for (int day in enabledDaysOfWeek) {
      for (int hour = 0; hour < 24; hour++) {
        bool isEnabled = enabledRegions.any((region) {
          return region.startTime.hour <= hour && region.endTime.hour > hour && region.recurrenceRule!.contains(GeneralFunctions.dayToWeekDay(day));
        });

        if (!isEnabled) {
          DateTime startTime = DateTime(now.year, now.month, now.day + (day - now.weekday + 7) % 7, hour, 0);
          DateTime endTime = DateTime(now.year, now.month, now.day + (day - now.weekday + 7) % 7, hour + 1, 0);

          disabledRegions.add(TimeRegion(
            startTime: startTime,
            endTime: endTime,
            color:  _isEmergency  ? Colors.green.shade100 :Colors.grey.shade200,
            enablePointerInteraction: _isEmergency  ? true : false,
            recurrenceRule: 'FREQ=WEEKLY;BYDAY=${GeneralFunctions.dayToWeekDay(day)};INTERVAL=1',
          ));
        }
      }
    }

    // Deshabilitar intervalos entre regiones habilitadas
    for (int day in enabledDaysOfWeek) {
      for (int i = 0; i < enabledRegions.length - 1; i++) {
        final region = enabledRegions[i];
        final nextRegion = enabledRegions[i + 1];
        if (region.endTime.minute != nextRegion.startTime.minute) {
          disabledRegions.add(TimeRegion(
            startTime: region.endTime,
            endTime: nextRegion.startTime,
            color:  _isEmergency  ? Colors.green.shade100 :Colors.grey.shade200,
            enablePointerInteraction: _isEmergency ? true : false,
            recurrenceRule: 'FREQ=WEEKLY;BYDAY=${GeneralFunctions.dayToWeekDay(day)};INTERVAL=1',
          ));
        }
      }
    }

    return disabledRegions;
  }

}



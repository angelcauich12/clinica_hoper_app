import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

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
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appointmentProv = Provider.of<AppointmentProvider>(context);
    final size = MediaQuery.of(context).size;
    User apiUser = User.fromJson(Preferences.apiUser);
    final appointmentForm = Provider.of<AppointmentProvider>(context);
    const myColor = Colors.lightBlue;

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
                    child: Center(
                      child: SpinKitCubeGrid(
                        color: ThemeProvider.secondColor,
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
                            return myColor; // Color cuando el paso está activo
                          }
                          return Colors
                              .grey; // Color predeterminado para otros estados
                        }),
                        controlsBuilder:
                            (BuildContext context, ControlsDetails details) {
                          return _currentStep > 0
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    if (details.onStepCancel != null)
                                      ElevatedButton(
                                        onPressed: details.onStepCancel,
                                        child: const Text(
                                          'Anterior',
                                          style: TextStyle(color: myColor),
                                        ),
                                      ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    if (details.onStepContinue != null)
                                      _currentStep > 1
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
                                'Paciente',
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
                          Step(
                              isActive: _currentStep >= 1,
                              state: _currentStep > 1
                                  ? StepState.complete
                                  : StepState.indexed,
                              title: const Text(''),
                              label: Text(
                                'Especialidad',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9,
                                    color: _currentStep >= 1
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
                                          child: ListView.separated(
                                              itemBuilder: (_, index) =>
                                                  ListTile(
                                                    trailing: const Icon(Icons
                                                        .navigate_next_rounded),
                                                    title: Text(appointmentProv
                                                            .specialties![index]
                                                            .name ??
                                                        ''),
                                                    onTap: () {
                                                      setState(() {
                                                        apiUser.miPerfil
                                                                    .nombre !=
                                                                'Doctor'
                                                            ? _currentStep += 1
                                                            : _currentStep += 2;
                                                      });
                                                    },
                                                  ),
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const Divider(),
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
                              isActive: _currentStep >= 2,
                              state: _currentStep > 2
                                  ? StepState.complete
                                  : StepState.indexed,
                              title: const Text(''),
                              label: Text(
                                'Doctor',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9,
                                    color: _currentStep >= 2
                                        ? myColor
                                        : Colors.grey),
                              ),
                              content: Container(
                                color: Colors.yellow,
                                child: const Text('Aquí van a ir los doctores'),
                              )),
                          Step(
                              isActive: _currentStep >= 3,
                              state: _currentStep > 3
                                  ? StepState.complete
                                  : StepState.indexed,
                              title: const Text(''),
                              label: Text(
                                'Fecha y hora',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9,
                                    color: _currentStep >= 3
                                        ? myColor
                                        : Colors.grey),
                              ),
                              content: Container(
                                color: Colors.yellow,
                                child:
                                    const Text('Aquí van a ir el calendario'),
                              ))
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

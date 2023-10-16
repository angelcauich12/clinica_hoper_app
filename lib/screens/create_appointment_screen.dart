import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/search/patient_search_delegate.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/input_decorations.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class CreateAppointmentScreen extends StatefulWidget {
  static const String routeName = 'create-appointment';

  @override
  State<CreateAppointmentScreen> createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _dateController.text = '';
    _searchController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appointmentProvider = Provider.of<AppointmentProvider>(
      context,
      listen: false,
    );
    final appointmentProv = Provider.of<AppointmentProvider>(context);
    final Color myColor = ThemeProvider.secondColor;

    final appointmentForm = Provider.of<AppointmentProvider>(context);
    User apiUser = User.fromJson(Preferences.apiUser);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomAppBar(
            title: 'Agendar Cita',
            image: 'assets/images/modules/doctorappointment.jpg',
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: appointmentForm.formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      (apiUser.miPerfil.nombre != 'Doctor')
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Especialidad',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: myColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: DropdownButtonFormField(
                                        key: appointmentForm
                                            .specialtyDropdownKey,
                                        // autovalidateMode: AutovalidateMode.onUserInteraction,
                                        decoration: const InputDecoration(
                                          focusedBorder: InputBorder.none,
                                          border: InputBorder.none,
                                        ),
                                        alignment: Alignment.center,
                                        hint: const Text(
                                          'Selecciona...',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        isExpanded: false,
                                        value:
                                            appointmentProv.specialtySelected,
                                        items: appointmentProv.specialties
                                            ?.map((specialty) {
                                          return DropdownMenuItem(
                                            alignment: Alignment.center,
                                            value: specialty.id.toString(),
                                            child: Text(
                                              specialty.name.toString(),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          print('Specialty Selected: $value');
                                          appointmentProv.specialtySelected =
                                              value;
                                          setState(() {
                                            final Specialty specialty =
                                                appointmentProv.specialties!
                                                    .firstWhere((specialty) =>
                                                        specialty.id
                                                            .toString() ==
                                                        appointmentProv
                                                            .specialtySelected);
                                            print(
                                                'Doctores ${specialty.doctors}');
                                            appointmentProv.doctors = [];
                                            appointmentProv.doctorSelected =
                                                null;
                                            appointmentForm
                                                .doctorDropdownKey.currentState
                                                ?.reset();
                                            appointmentProv.doctors =
                                                specialty.doctors!.toList();
                                          });
                                          print(appointmentProv.doctors);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Doctor',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: myColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      flex: 2,
                                      child: DropdownButtonFormField(
                                        key: appointmentForm.doctorDropdownKey,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: const InputDecoration(
                                          focusedBorder: InputBorder.none,
                                          border: InputBorder.none,
                                        ),
                                        hint: const Text(
                                          'Selecciona...',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        isExpanded: true,
                                        value:
                                            appointmentProvider.doctorSelected,
                                        items: appointmentProvider.doctors!
                                            .map((doctor) {
                                          return DropdownMenuItem(
                                            alignment: Alignment.center,
                                            value: doctor.id.toString(),
                                            child: Text(
                                              '${doctor.name} ${doctor.lastName}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) =>
                                            appointmentProvider.doctorSelected =
                                                value,
                                      ),
                                    ),
                                  ],
                                ),
                                (apiUser.miPerfil.nombre == 'Admin')
                                    ? TextFormField(
                                        readOnly: true,
                                        controller: _searchController,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecorations
                                            .authInputDecoration(
                                                color: myColor,
                                                hintText: 'John Doe',
                                                labelText: 'Paciente',
                                                suffixIcon:
                                                    Icons.search_outlined),
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
                                      )
                                    : Container(),
                                const SizedBox(height: 15),
                              ],
                            )
                          : Column(
                              children: [
                                TextFormField(
                                  readOnly: true,
                                  controller: _searchController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration:
                                      InputDecorations.authInputDecoration(
                                          color: myColor,
                                          hintText: 'John Doe',
                                          labelText: 'Paciente',
                                          suffixIcon: Icons.search_outlined),
                                  onTap: () async {
                                    await showSearch(
                                      context: context,
                                      delegate: PatientSearchDelegate(),
                                    );
                                    if (appointmentProv.patientFullName != '') {
                                      _searchController.text =
                                          appointmentProv.patientFullName;
                                    }
                                  },
                                  validator: (value) {
                                    return (value != null && value.length >= 3)
                                        ? null
                                        : 'Paciente debe contener más de 3 caracteres.';
                                  },
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Especialidad',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: myColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: DropdownButtonFormField(
                                        key: appointmentForm
                                            .specialtyDropdownKey,
                                        // autovalidateMode: AutovalidateMode.onUserInteraction,
                                        decoration: const InputDecoration(
                                          focusedBorder: InputBorder.none,
                                          border: InputBorder.none,
                                        ),
                                        alignment: Alignment.center,
                                        hint: const Text(
                                          'Selecciona...',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        isExpanded: false,
                                        value:
                                            appointmentProv.specialtySelected,
                                        items: apiUser.specialties
                                            ?.map((specialty) {
                                          return DropdownMenuItem(
                                            alignment: Alignment.center,
                                            value: specialty.id.toString(),
                                            child: Text(
                                              specialty.name.toString(),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          appointmentProv.specialtySelected =
                                              value;
                                          appointmentProv.doctorSelected =
                                              apiUser.id.toString();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      TextFormField(
                        autovalidateMode: (appointmentProv.isLoading)
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        controller: _dateController,
                        readOnly: true,
                        decoration: InputDecorations.authInputDecoration(
                            color: myColor,
                            hintText: '10-04-1979',
                            labelText: 'Fecha Cita',
                            suffixIcon: Icons.calendar_month_outlined),
                        textAlign: TextAlign.center,
                        onTap: (appointmentProv.doctorSelected != null)
                            ? () async {
                                DateTime? selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2025),
                                );

                                if (selectedDate == null) return; //if Cancel

                                setState(() {
                                  var formattedDate = DateFormat('yyyy-MM-dd')
                                      .format(selectedDate);
                                  print(
                                      'si Se pudo ${formattedDate.toString()}');
                                  appointmentProv.startDate = formattedDate;
                                  _dateController.text = formattedDate;
                                });
                                appointmentProv.allIntervals = [];
                                final result =
                                    await appointmentProv.scheduleIntervals();
                                print('Result ******* $result');
                                appointmentProv.startTime = null;
                                appointmentForm
                                    .intervalsDropdownKey.currentState
                                    ?.reset();
                                if (result == false) {
                                  appointmentProv.allIntervals = [];
                                  // Notifications.showSnackBar(appointmentProv
                                  //         .serverResponse?.message
                                  //         ?.substring(0, 50) ??
                                  //     'Error Desconocido.');
                                }
                              }
                            : null,
                        validator: (value) {
                          return (value != null && value.length >= 10)
                              ? null
                              : 'Debe escoger una fecha y un horario.';
                        },
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Horario',
                              style: TextStyle(
                                fontSize: 16,
                                color: myColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField(
                              key: appointmentForm.intervalsDropdownKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                focusedBorder: InputBorder.none,
                                border: InputBorder.none,
                              ),
                              hint: const Text(
                                'Selecciona...',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              alignment: Alignment.center,
                              isExpanded: true,
                              value: appointmentProv.startTime,
                              items:
                                  appointmentProv.allIntervals!.map((interval) {
                                return DropdownMenuItem(
                                  alignment: Alignment.center,
                                  value: interval,
                                  child: Text(
                                    interval,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) =>
                                  appointmentProv.startTime = value,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        autocorrect: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: 4,
                        decoration: InputDecorations.authInputDecoration(
                            color: myColor,
                            hintText:
                                'Describa brevemente la razón de su visita',
                            labelText: 'Descripción',
                            suffixIcon: Icons.description_outlined),
                        onChanged: (value) =>
                            appointmentProv.description = value,
                        validator: (value) {
                          return (value != null && value.length >= 3)
                              ? null
                              : 'La descripción debe contener más de 3 caracteres.';
                        },
                      ),
                      const SizedBox(height: 35),
                      MaterialButton(
                        onPressed: (appointmentProv.isLoading)
                            ? null
                            : () async {
                                if (!appointmentProv.isValidForm()) return;
                                appointmentProv.isLoading = true;
                                FocusScope.of(context).unfocus();

                                //hacer la peticion al backend
                                final result =
                                    await appointmentProv.createAppointment();

                                print('Result $result');
                                if (!result) {
                                  setState(() {
                                    appointmentProv.startDate = null;
                                    appointmentProv.morningIntervals = [];
                                    appointmentForm
                                        .intervalsDropdownKey.currentState
                                        ?.reset();
                                    appointmentForm.formKey.currentState
                                        ?.reset();
                                  });
                                  _dateController.clear();
                                } else {
                                  setState(() {
                                    appointmentProv.morningIntervals = [];
                                    appointmentForm
                                        .intervalsDropdownKey.currentState
                                        ?.reset();

                                    appointmentProv.startDate = null;
                                    appointmentProv.doctors = [];
                                    appointmentProv.doctorSelected = null;
                                    appointmentProv.patientSelected = null;
                                    appointmentProv.patientFullName = '';
                                    appointmentForm
                                        .doctorDropdownKey.currentState
                                        ?.reset();
                                    appointmentProv.specialtySelected = null;
                                    appointmentForm
                                        .specialtyDropdownKey.currentState
                                        ?.reset();
                                    appointmentForm.formKey.currentState
                                        ?.reset();
                                  });
                                  _dateController.clear();
                                  _searchController.clear();

                                  Notifications.showSnackBar(
                                      'Cita creada correctamente.');
                                }

                                appointmentProv.isLoading = false;
                              },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        disabledColor: Colors.grey,
                        elevation: 0,
                        color: myColor,
                        minWidth: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Text(
                            appointmentProvider.isLoading
                                ? 'Espere'
                                : 'Agendar Cita',
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ]),
          )
        ],
      ),
    );
  }
}

class ExpandedTitle extends StatelessWidget {
  String title;

  ExpandedTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: 25,
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

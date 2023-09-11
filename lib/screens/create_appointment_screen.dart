import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hope_app/models/appointments_response.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/input_decorations.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateAppointmentScreen extends StatefulWidget {
  static const String routeName = 'create-appointment';

  @override
  State<CreateAppointmentScreen> createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _dateController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appointmentProvider = Provider.of<AppointmentProvider>(
      context,
      listen: false,
    );
    final Color myColor = ThemeProvider.secondColor;
    GlobalKey<FormState> dropdownKey = GlobalKey<FormState>();

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
                  key: appointmentProvider.formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                              value: appointmentProvider.specialtySelected,
                              items: appointmentProvider.specialties
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
                                setState(() {
                                  appointmentProvider.specialtySelected = value;
                                  final Specialty specialty =
                                      appointmentProvider.specialties!
                                          .firstWhere((specialty) =>
                                              specialty.id.toString() ==
                                              appointmentProvider
                                                  .specialtySelected);
                                  appointmentProvider.doctors = [];
                                  appointmentProvider.doctorSelected = null;
                                  dropdownKey.currentState?.reset();
                                  appointmentProvider.doctors =
                                      specialty.doctors!.toList();
                                });
                                print(appointmentProvider.doctors);
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
                              key: dropdownKey,
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
                              value: appointmentProvider.doctorSelected,
                              items: appointmentProvider.doctors!.map((doctor) {
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
                              onChanged: (value) {
                                print('Doctor Selected: $value');
                                appointmentProvider.doctorSelected = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        autocorrect: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: 4,
                        decoration: InputDecorations.authInputDecoration(
                            color: myColor,
                            hintText:
                                'Describa brevemente la razon de su visita',
                            labelText: 'Descripción',
                            suffixIcon: Icons.description_outlined),
                        onChanged: (value) =>
                            appointmentProvider.maritalStatus = value,
                        validator: (value) {
                          return (value != null && value.length >= 3)
                              ? null
                              : 'Estado civil debe contener más de 3 caracteres.';
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: InputDecorations.authInputDecoration(
                            color: myColor,
                            hintText: '10-04-1979',
                            labelText: 'Fecha Cita',
                            suffixIcon: Icons.calendar_month_outlined),
                        textAlign: TextAlign.center,
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2025),
                          );

                          if (selectedDate == null) return; //if Cancel

                          setState(() {
                            var formattedDate =
                                DateFormat('yyyy-MM-dd').format(selectedDate);
                            print('si Se pudo ${formattedDate.toString()}');
                            appointmentProvider.startDate = formattedDate;
                            _dateController.text = formattedDate;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          ExpandedTitle(title: 'Hora Inicial'),
                          const SizedBox(width: 10),
                          ExpandedTitle(title: 'Hora Final'),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                TimeOfDay? newStartTime = await showTimePicker(
                                    context: context,
                                    initialTime: appointmentProvider.startTime);

                                if (newStartTime == null) return; //if Cancel

                                setState(() {
                                  appointmentProvider.startTime = newStartTime;
                                  appointmentProvider.endTime = newStartTime;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    "${appointmentProvider.startTime.hour}:${appointmentProvider.startTime.minute}",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                TimeOfDay? newEndTime = await showTimePicker(
                                    context: context,
                                    initialTime: appointmentProvider.startTime);

                                if (newEndTime == null) return; //if Cancel

                                setState(() =>
                                    appointmentProvider.endTime = newEndTime);
                              },
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    "${appointmentProvider.endTime.hour}:${appointmentProvider.endTime.minute}",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 35),
                      MaterialButton(
                        onPressed: appointmentProvider.isLoading
                            ? null
                            : () async {
                                if (!appointmentProvider.isValidForm()) return;
                                appointmentProvider.isLoading = true;
                                FocusScope.of(context).unfocus();

                                //hacer la peticion al backend
                                print('Peticion al backend!!');

                                appointmentProvider.isLoading = false;
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

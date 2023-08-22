import 'package:flutter/material.dart';
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
    final appointmentForm = Provider.of<AppointmentFormProvider>(context);
    final Color myColor = ThemeProvider.blueColor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomAppBar(
            title: 'Agendar Cita',
            image:
                'https://www.workmethods.com/img/casestudies/doctorappointment.jpg',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
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
                              alignment: AlignmentDirectional.center,
                              isExpanded: true,
                              value: appointmentForm.specialty,
                              items: const [
                                DropdownMenuItem(
                                    value: 1,
                                    alignment: AlignmentDirectional.center,
                                    child: Text('Ginecología')),
                                DropdownMenuItem(
                                    value: 2,
                                    alignment: AlignmentDirectional.center,
                                    child: Text('Odontología')),
                                DropdownMenuItem(
                                    value: 3,
                                    alignment: AlignmentDirectional.center,
                                    child: Text('Pediatría')),
                                DropdownMenuItem(
                                    value: 4,
                                    alignment: AlignmentDirectional.center,
                                    child: Text('Alergología')),
                                DropdownMenuItem(
                                    value: 5,
                                    alignment: AlignmentDirectional.center,
                                    child: Text('Nutrición')),
                              ],
                              onChanged: (value) {
                                // print(value);
                                appointmentForm.specialty = value ?? 1;
                              },
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        autocorrect: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.name,
                        decoration: InputDecorations.authInputDecoration(
                            color: myColor,
                            hintText: 'Médico que atenderá la cita.',
                            labelText: 'Médico',
                            suffixIcon: Icons.medical_services_outlined),
                        onChanged: (value) => appointmentForm.ocupation = value,
                        validator: (value) {
                          return (value != null && value.length >= 3)
                              ? null
                              : 'Médico debe contener más de 3 caracteres.';
                        },
                      ),
                      const SizedBox(height: 15),
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
                            appointmentForm.maritalStatus = value,
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
                            appointmentForm.startDate = formattedDate;
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
                                    initialTime: appointmentForm.startTime);

                                if (newStartTime == null) return; //if Cancel

                                setState(() {
                                  appointmentForm.startTime = newStartTime;
                                  appointmentForm.endTime = newStartTime;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    "${appointmentForm.startTime.hour}:${appointmentForm.startTime.minute}",
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
                                    initialTime: appointmentForm.startTime);

                                if (newEndTime == null) return; //if Cancel

                                setState(
                                    () => appointmentForm.endTime = newEndTime);
                              },
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    "${appointmentForm.endTime.hour}:${appointmentForm.endTime.minute}",
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
                        onPressed: appointmentForm.isLoading
                            ? null
                            : () async {
                                if (!appointmentForm.isValidForm()) return;
                                appointmentForm.isLoading = true;
                                FocusScope.of(context).unfocus();

                                //hacer la peticion al backend
                                print('Peticion al backend!!');

                                appointmentForm.isLoading = false;
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
                            appointmentForm.isLoading
                                ? 'Espere'
                                : 'Agendar Cita',
                            style: const TextStyle(color: Colors.white),
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

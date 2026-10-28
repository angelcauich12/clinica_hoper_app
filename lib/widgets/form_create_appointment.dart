import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/search/patient_search_delegate.dart';
import 'package:provider/provider.dart';

import '../ui/input_decorations.dart';

class FormCreateAppointment extends StatefulWidget {
  const FormCreateAppointment({super.key});

  @override
  State<FormCreateAppointment> createState() => _FormCreateAppointmentState();
}

class _FormCreateAppointmentState extends State<FormCreateAppointment> {
  // bool _isChecked = false;
  final TextEditingController _searchController = TextEditingController();
  // bool _isExpanded = false;
  // final ExpansionTileController _expansionController =
  //     ExpansionTileController();
  // bool _isEmpty = true;
  bool light1 = false;

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  Widget build(BuildContext context) {
    final appointmentProv = Provider.of<AppointmentProvider>(context);
    final myColor = ThemeProvider.secondColor;
    final appointmentForm = Provider.of<AppointmentProvider>(context);

    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: appointmentForm.formKey,
        child: Column(
          children: [
            TextFormField(
              readOnly: true,
              controller: _searchController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecorations.authInputDecoration(
                  color: myColor,
                  hintText: 'Buscar paciente',
                  // labelText: 'Paciente',
                  suffixIcon: Icons.search_outlined),
              onTap: () async {
                await showSearch(
                  context: context,
                  delegate: PatientSearchDelegate(),
                );
                if (appointmentProv.patientFullName != '') {
                  _searchController.text = appointmentProv.patientFullName;
                }
              },
              validator: (value) {
                //  if (value != null)  _handleTextChanged();
                return (value != null && value.length >= 3)
                    ? null
                    : 'Paciente debe contener más de 3 caracteres.';
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              minLines: 1,
              maxLines: 2,
              initialValue: 'Consulta',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: myColor)),
                  counterText: '',
                  border: const OutlineInputBorder(),
                  hintText: 'Describa brevemente la razón de la cita',
                  hintStyle: TextStyle(color: Colors.grey[350], fontSize: 14),
                  labelText: 'Descripción',
                  labelStyle: TextStyle(color: myColor)),
              keyboardType: TextInputType.multiline,
              maxLength: 40,
              onChanged: (value) => appointmentProv.description = value,
              validator: (value) {
                return (value != null && value.length >= 3)
                    ? null
                    : 'La descripción debe contener más de 3 caracteres.';
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: myColor,
                      ),
                      onPressed: () async {
                        if (!appointmentProv.isValidForm()) return;
                        FocusScope.of(context).unfocus();
                        Navigator.pop(context);
                        final result =
                            await appointmentProv.createAppointment();
                        if (result) {
                          appointmentProv.patientSelected = null;
                          appointmentProv.startDate = null;
                          appointmentForm.endTime = null;
                          appointmentProv.startTime = null;
                          appointmentProv.doctorSelected = null;
                          _searchController.clear();
                        }
                      },
                      child: const Text(
                        'Agendar Cita',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

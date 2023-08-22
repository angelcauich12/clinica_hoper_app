import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/home_screen.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/input_decorations.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MedicalRecordsScreen extends StatefulWidget {
  static const String routeName = 'medical-records';

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _dateController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final medicalRecordsForm = Provider.of<MedicalRecordsFormProvider>(context);
    final Color myColor = ThemeProvider.blueColor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomAppBar(
            title: 'Historial Clínico',
            image:
                'https://www.totalvoicetech.com/wp-content/uploads/medical-records.jpg',
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: medicalRecordsForm.formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: InputDecorations.authInputDecoration(
                            color: myColor,
                            hintText: '10-04-1979',
                            labelText: 'F. Nacimiento',
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
                            medicalRecordsForm.birthday = formattedDate;
                            _dateController.text = formattedDate;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              'Género',
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
                              value: Preferences.gender,
                              items: const [
                                DropdownMenuItem(
                                    value: 'F',
                                    alignment: AlignmentDirectional.center,
                                    child: Text('Femenino')),
                                DropdownMenuItem(
                                    value: 'M',
                                    alignment: AlignmentDirectional.center,
                                    child: Text('Masculino')),
                                DropdownMenuItem(
                                    value: 'O',
                                    alignment: AlignmentDirectional.center,
                                    child: Text('Otro')),
                              ],
                              onChanged: (value) {
                                // print(value);
                                Preferences.gender = value ?? 'F';
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
                            hintText: 'A que se dedica el paciente.',
                            labelText: 'Ocupación',
                            suffixIcon: Icons.work_outline_sharp),
                        onChanged: (value) =>
                            medicalRecordsForm.ocupation = value,
                        validator: (value) {
                          return (value != null && value.length >= 3)
                              ? null
                              : 'Ocupación debe contener más de 3 caracteres.';
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        autocorrect: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.name,
                        decoration: InputDecorations.authInputDecoration(
                            color: myColor,
                            hintText: 'casado/soltero/divorciado/viudo',
                            labelText: 'Estado Civil',
                            suffixIcon: Icons.people_alt_outlined),
                        onChanged: (value) =>
                            medicalRecordsForm.maritalStatus = value,
                        validator: (value) {
                          return (value != null && value.length >= 3)
                              ? null
                              : 'Estado civil debe contener más de 3 caracteres.';
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        autocorrect: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                        decoration: InputDecorations.authInputDecoration(
                            color: myColor,
                            hintText: 'Teléfono del paciente',
                            labelText: 'Teléfono',
                            suffixIcon: Icons.phone_enabled_outlined),
                        onChanged: (value) => medicalRecordsForm.phone = value,
                        validator: (value) {
                          return (value != null && value.length >= 3)
                              ? null
                              : 'Dirección debe contener más de 3 caracteres.';
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        autocorrect: false,
                        keyboardType: TextInputType.name,
                        decoration: InputDecorations.authInputDecoration(
                            color: myColor,
                            hintText: 'John Doe',
                            labelText: 'Contacto de Emergencia',
                            suffixIcon: Icons.person_pin_outlined),
                        onChanged: (value) =>
                            medicalRecordsForm.contactName = value,
                        validator: (value) {
                          return (value != null && value.length >= 3)
                              ? null
                              : 'Contacto debe contener más de 3 caracteres.';
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        decoration: InputDecorations.authInputDecoration(
                            color: myColor,
                            hintText: 'XXXX-XXXXXX',
                            labelText: 'Teléfono de Contacto',
                            suffixIcon: Icons.phone_android_outlined),
                        onChanged: (value) =>
                            medicalRecordsForm.contactPhone = value,
                        validator: (value) {
                          return (value != null && value.length >= 10)
                              ? null
                              : 'Contacto debe contener 10 numeros.';
                        },
                      ),
                      const SizedBox(height: 35),
                      MaterialButton(
                        onPressed: medicalRecordsForm.isLoading
                            ? null
                            : () async {
                                if (!medicalRecordsForm.isValidForm()) return;
                                medicalRecordsForm.isLoading = true;
                                FocusScope.of(context).unfocus();

                                //hacer la peticion al backend
                                print('Peticion al backend!!');

                                medicalRecordsForm.isLoading = false;
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
                            medicalRecordsForm.isLoading
                                ? 'Espere'
                                : 'Guardar Historia',
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

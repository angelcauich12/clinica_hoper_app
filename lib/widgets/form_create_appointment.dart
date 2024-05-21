import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  bool _isChecked = false;
  final TextEditingController _searchController = TextEditingController();
  bool _isExpanded = false;
  final ExpansionTileController _expansionController =
      ExpansionTileController();
  bool _isEmpty = true;
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
    return Padding(
        padding: const EdgeInsetsDirectional.only(
             start: 12.0, end: 12.0, bottom: 20 ),
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
            // ExpansionTile(
            //     controller: _expansionController,
            //     tilePadding: EdgeInsetsDirectional.zero,
            //     title: const Text('Paciente nuevo'),
            //     enabled: _isExpanded,
            //     collapsedBackgroundColor: Colors.transparent,
            //     backgroundColor: Colors.transparent,
            //     trailing: Checkbox(
            //       activeColor: myColor,
            //       value: _isChecked,
            //       onChanged: !_isEmpty
            //           ? null
            //           : (bool? value) {
            //               setState(() {
            //                 _isChecked = value!;
            //                 _isExpanded = value;
            //                 if (!_isExpanded) {
            //                   _expansionController.collapse();
            //                 } else {
            //                   _expansionController.expand();
            //                 }
            //               });
            //             },
            //     ),
            //     onExpansionChanged: (value) {
            //       setState(() {
            //         _isChecked = value;
            //         _isExpanded = value;
            //       });
            //     },
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.symmetric(vertical: 5),
            //         child: Column(
            //           children: [
            //             SizedBox(
            //               height: MediaQuery.of(context).size.height *
            //                   0.05, // 5% de la pantalla
            //               child: TextFormField(
            //                 onChanged: (value) {},
            //                 validator: (value) {
            //                   // if (value == null) return 'Este campo es requerido';
            //                   // if (value.isEmpty) return 'Requerido';
            //                   // if (int.parse(value) > 10) return 'Menor a 10';
            //                   // return value == '0' ? 'Mayor a 0' : null;
            //                 },
            //                 autovalidateMode:
            //                     AutovalidateMode.onUserInteraction,
            //                 decoration: const InputDecoration(
            //                     counterText: '',
            //                     border: OutlineInputBorder(),
            //                     hintText: 'Nombres',
            //                     labelText: 'Nombres'),
            //                 keyboardType: TextInputType.text,
            //                 maxLength: 37,
            //               ),
            //             ),
            //             const SizedBox(height: 9),
            //             SizedBox(
            //               height: MediaQuery.of(context).size.height * 0.05,
            //               child: TextFormField(
            //                 onChanged: (value) {},
            //                 validator: (value) {
            //                   // if (value == null) return 'Este campo es requerido';
            //                   // if (value.isEmpty) return 'Requerido';
            //                   // if (int.parse(value) > 10) return 'Menor a 10';
            //                   // return value == '0' ? 'Mayor a 0' : null;
            //                 },
            //                 autovalidateMode:
            //                     AutovalidateMode.onUserInteraction,
            //                 decoration: const InputDecoration(
            //                     counterText: '',
            //                     border: OutlineInputBorder(),
            //                     hintText: 'Apellidos',
            //                     labelText: 'Apellidos'),
            //                 keyboardType: TextInputType.text,
            //                 maxLength: 37,
            //               ),
            //             ),
            //             const SizedBox(height: 9),
            //             SizedBox(
            //               height: MediaQuery.of(context).size.height * 0.05,
            //               child: TextFormField(
            //                 onChanged: (value) {},
            //                 validator: (value) {
            //                   // if (value == null) return 'Este campo es requerido';
            //                   // if (value.isEmpty) return 'Requerido';
            //                   // if (int.parse(value) > 10) return 'Menor a 10';
            //                   // return value == '0' ? 'Mayor a 0' : null;
            //                 },
            //                 autovalidateMode:
            //                     AutovalidateMode.onUserInteraction,
            //                 decoration: const InputDecoration(
            //                     counterText: '',
            //                     border: OutlineInputBorder(),
            //                     hintText: 'Telefono',
            //                     labelText: 'Telefono'),
            //                 keyboardType: TextInputType.number,
            //                 maxLength: 10,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ]),
            const SizedBox(height: 15),
            TextFormField(
              initialValue: 'Consulta',
              onChanged: (value) {},
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(),
                  hintText: 'Descripción',
                  labelText: 'Descripción'),
              keyboardType: TextInputType.text,
              maxLength: 37,
            ),
            Row(
              children: [
                const Text('(Emergencia)'),
                Switch(
                  activeColor: Colors.white,
                  activeTrackColor: myColor,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey.shade400,
                  thumbIcon: thumbIcon,
                  value: light1,
                  onChanged: (bool value) {
                    setState(() {
                      light1 = value;
                    });
                  },
                ),
              ],
            ),
            OutlinedButton.icon(
              icon: Icon(Icons.access_time_outlined, color: myColor),
              label: Text(
                'Hora final',
                style: TextStyle(color: myColor),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        'Seleccione hora final',
                      ),
                      content: SizedBox(
                        width: 200,
                        height: 100,
                        child: CupertinoPicker(
                          itemExtent: 33,
                          onSelectedItemChanged: (value) {},
                          children: List.generate(
                            34,
                            (index) => Text("$index"),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                      backgroundColor: myColor,
                    ),
                    onPressed: () {
                  }, 
                  child:  const Text('Guardar' , style: TextStyle(color: Colors.white),)),
                ),
              ],
            )
          ],
        ));
  }
}

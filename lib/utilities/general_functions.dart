import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../ui/input_decorations.dart';

class GeneralFunctions{
  
   
   //format time 12 hours
   static String formatTime(String value) {
    DateTime parsedValue = DateFormat('HH:mm').parse(value);
     final DateFormat formattedTime = DateFormat('HH:mm a');
    return formattedTime.format(parsedValue);
  }


  static String formatDate(String value){
    DateTime parsedValue = DateFormat('yyyy-MM-dd').parse(value);
     final DateFormat formattedTime = DateFormat('MM/dd/yyyy');
    return formattedTime.format(parsedValue);
  }

  static Future<bool> showCancelAppointment(BuildContext context, String id,) async {
    final cancelForm = Provider.of<CancelAppointmentFormProvider>(context, listen: false);
    final appointmentProv = Provider.of<AppointmentProvider>(context, listen: false);
    bool resultAppointment;
    var result = await showDialog<bool>(
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
            onPressed: () => Navigator.pop(context),
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
            onPressed: () async {
              if (!cancelForm.isValidForm()) return;
              resultAppointment =  await appointmentProv.cancelAppointment(id, cancelForm.justification); 
             if (context.mounted) {
                Navigator.pop(context, resultAppointment);
              }
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
   

    return result!;
  }

}
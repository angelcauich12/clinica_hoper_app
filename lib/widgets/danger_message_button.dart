import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';

class DangerMessageWithButton extends StatelessWidget {
  Color color;
  String title;
  String paragraph1;
  String paragraph2;

  DangerMessageWithButton(
      {required this.color,
      required this.title,
      required this.paragraph1,
      required this.paragraph2});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color,
      ),
      width: double.infinity,
      child: Center(
        child: Column(
          children: [
            _Paragraph(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              size: 16,
              text: title,
            ),
            const SizedBox(height: 10),
            _Paragraph(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              size: 16,
              text: paragraph1,
            ),
            SizedBox(height: (paragraph2 != '') ? 15 : 0),
            _Paragraph(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              size: 16,
              text: paragraph2,
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, MedicalRecordsScreen.routeName),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 251, 106, 106),
                  shape: const StadiumBorder()),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Text(
                  'Rellenar Expediente',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                    color: ThemeProvider.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  String text;
  double size;
  FontWeight fontWeight;
  Color color;

  _Paragraph(
      {required this.fontWeight,
      required this.size,
      required this.text,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
        fontFamily: 'Roboto',
        color: color,
        shadows: const [
          Shadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 7.0,
            color: Colors.black26,
          ),
        ],
      ),
      textAlign: TextAlign.justify,
    );
  }
}

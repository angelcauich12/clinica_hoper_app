import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';

class DangerMessageWithButton extends StatelessWidget {
  Color color;
  String title;
  String btnTitle;
  String paragraph1;
  String paragraph2;

  DangerMessageWithButton(
      {required this.color,
      required this.title,
      required this.btnTitle,
      required this.paragraph1,
      this.paragraph2 = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Paragraph(
              color: ThemeProvider.white,
              fontWeight: FontWeight.bold,
              size: 16,
              text: title,
            ),
            const SizedBox(height: 5),
            _Paragraph(
              color: ThemeProvider.white,
              fontWeight: FontWeight.bold,
              size: 16,
              text: paragraph1,
            ),
            (paragraph2 != '')
                ? Column(
                    children: [
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, MedicalRecordsScreen.routeName),
                        child: _Paragraph(
                          color: ThemeProvider.blue,
                          fontWeight: FontWeight.bold,
                          size: 16,
                          text: paragraph2,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            // ElevatedButton(
            //   onPressed: () =>
            //       Navigator.pushNamed(context, MedicalRecordsScreen.routeName),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: ThemeProvider.lightRed,
            //   ),
            //   child: Padding(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            //     child: Text(
            //       btnTitle,
            //       style: TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.w600,
            //         fontFamily: 'Roboto',
            //         color: ThemeProvider.white,
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 10),
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
  TextDecoration decoration;

  _Paragraph(
      {required this.fontWeight,
      required this.size,
      required this.text,
      this.decoration = TextDecoration.none,
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
        decoration: decoration,
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

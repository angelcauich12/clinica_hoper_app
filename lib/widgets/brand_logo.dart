import 'package:flutter/material.dart';

class LogoBrand extends StatelessWidget {
  const LogoBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 70,
      child: Image(
        image: AssetImage('assets/images/brand/hoper-logo.png'),
      ),
    );
  }
}

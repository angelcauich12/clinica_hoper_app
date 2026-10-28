import 'package:flutter/material.dart';

class LogoBrand extends StatelessWidget {
  const LogoBrand({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    
    return  SizedBox(
      height: (size.height > 1024 && orientation == Orientation.portrait) ? 100:70,
      child: const Image(
        image: AssetImage('assets/images/brand/hoper-logo.png'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/widgets/widgets.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)!.settings.name;
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                const Color(0xff126276).withAlpha(255),
                const Color(0xff126276).withAlpha(230),
                const Color(0xff126276).withAlpha(200),
              ],
            ),
          ),
        ),
        const SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LogoBrand(),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.only(top: 25),
            width: size.width,
            height: size.height * 0.7,
            decoration: BoxDecoration(
              color: ThemeProvider.fourColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(45),
                topRight: Radius.circular(45),
              ),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}

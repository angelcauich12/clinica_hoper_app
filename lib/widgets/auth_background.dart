import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)!.settings.name;

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          const _BackgroundImage(),
          const Positioned(
            bottom: 20,
            right: 30,
            child: LogoBrand(),
          ),
          Center(
            child: child,
          )
          //child
        ],
      ),
    );
  }

  BoxDecoration _LinearGradient() => BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            ThemeProvider.lightColor,
            ThemeProvider.blueColor,
          ]));
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: const Image(
        image: AssetImage('assets/clinic00.jpg'),
        fit: BoxFit.cover,
        opacity: AlwaysStoppedAnimation(.5),
      ),
    );
  }
}

class LogoBrand extends StatelessWidget {
  const LogoBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 70,
      child: Image(image: AssetImage('assets/hoper-logo.png')),
    );
  }
}

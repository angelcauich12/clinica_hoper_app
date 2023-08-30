import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/auth_service.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/input_decorations.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = 'login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final oneSignalProvider = Provider.of<OneSignalProvider>(context);
    oneSignalProvider.initOneSignal(context);

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CardContainer(
                child: Column(
                  children: [
                    ChangeNotifierProvider(
                      create: (context) => LoginFormProvider(),
                      child: const _LoginForm(),
                    ),
                    const SizedBox(height: 10),
                    _newAccountButton(),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _newAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(const StadiumBorder()),
      ),
      onPressed: () => Navigator.pushReplacementNamed(
        context,
        RegisterScreen.routeName,
      ),
      child: Text(
        'Crear nueva cuenta',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width80 = (size.width * 0.15);
    final loginForm = Provider.of<LoginFormProvider>(context);
    final Color myColor = Preferences.isDarkMode
        ? ThemeProvider.darkColor
        : ThemeProvider.secondColor;
    final oneSignalProvider = Provider.of<OneSignalProvider>(context);

    Timer(
      const Duration(seconds: 10),
      () => oneSignalProvider.setOneSignalId(),
    );

    return Container(
      child: Form(
          key: loginForm.formKey,
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    color: myColor,
                    hintText: 'correo@mail.com',
                    labelText: 'Email',
                    prefixIcon: Icons.person_outline),
                onChanged: (value) => loginForm.email = value,
                validator: (value) {
                  // return (value != null) ? null : 'no válido.';
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = RegExp(pattern);
                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'Correo inválido.';
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecorations.authInputDecoration(
                    color: myColor,
                    hintText: 'Mínimo 9 caracteres',
                    labelText: 'Contraseña',
                    prefixIcon: Icons.lock_outlined),
                onChanged: (value) => loginForm.password = value,
                validator: (value) {
                  return (value != null && value.length >= 6)
                      ? null
                      : 'Contraseña inválida.';
                },
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        if (!loginForm.isValidForm()) return;
                        loginForm.isLoading = true;
                        FocusScope.of(context).unfocus();

                        //hacer la peticion al backend para validar usuario
                        final authService =
                            Provider.of<AuthService>(context, listen: false);
                        final String? loginMessage = await authService
                            .loginUser(loginForm.email, loginForm.password);

                        if (loginMessage != 'true') {
                          print(
                              'No se logueo: ${loginForm.email}, ${loginForm.password}');

                          Notifications.showSnackBar(loginMessage.toString());
                          loginForm.isLoading = false;
                          return;
                        }

                        oneSignalProvider.saveUpdateId();
                        loginForm.isLoading = false;
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacementNamed(
                          context,
                          Home.routeName,
                        );
                      },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: myColor,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: width80, vertical: 15),
                  child: Text(
                    loginForm.isLoading ? 'Espere' : 'Iniciar Sesión',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

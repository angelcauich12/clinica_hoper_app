import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/input_decorations.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = 'registro';

  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: _RegisterForm(),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final registerForm = Provider.of<RegisterFormProvider>(context);
    final Color myColor = ThemeProvider.secondColor;

    final oneSignalProvider = Provider.of<OneSignalProvider>(context);

    Timer(
      const Duration(seconds: 10),
      () => oneSignalProvider.setOneSignalId(),
    );

    return Column(
      children: [
        Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 15),
          margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
          decoration: BoxDecoration(
            color: Preferences.isDarkMode
                ? ThemeProvider.darkColor
                : ThemeProvider.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xff126276).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8)),
            ],
          ),
          child: Form(
            key: registerForm.registerFormKey,
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  autocorrect: true,
                  keyboardType: TextInputType.name,
                  decoration: InputDecorations.authInputDecoration(
                      color: Colors.grey[350]!,
                      hintText: 'Mínimo 3 caracteres',
                      labelText: 'Nombre',
                      prefixIcon: Icons.person_2_outlined),
                  onChanged: (value) => registerForm.name = value,
                  validator: (value) {
                    return (value != null && value.length >= 3)
                        ? null
                        : 'Debe contener mínimo 3 caracteres';
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  autocorrect: true,
                  keyboardType: TextInputType.name,
                  decoration: InputDecorations.authInputDecoration(
                      color: Colors.grey[350]!,
                      hintText: 'Mínimo 3 caracteres',
                      labelText: 'Apellidos',
                      prefixIcon: Icons.person_4_outlined),
                  onChanged: (value) => registerForm.lastName = value,
                  validator: (value) {
                    return (value != null && value.length >= 3)
                        ? null
                        : 'Debe contener mínimo 3 caracteres';
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecorations.authInputDecoration(
                    color: Colors.grey[350]!,
                    hintText: '999X-XXXXXX',
                    labelText: 'Celular',
                    prefixIcon: Icons.phone_android_outlined,
                  ),
                  onChanged: (value) => registerForm.phone = value,
                  validator: (value) {
                    String pattern =
                        r'^(\+\d{1,2}\s?)?1?\-?\.?\s?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$';
                    RegExp regExp = RegExp(pattern);
                    return regExp.hasMatch(value ?? '')
                        ? null
                        : 'Número Inválido';
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  autocorrect: false,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecorations.authInputDecoration(
                      color: Colors.grey[350]!,
                      hintText: 'Mínimo 9 caracteres',
                      labelText: 'Contraseña',
                      prefixIcon: Icons.lock_outlined),
                  onChanged: (value) => registerForm.password = value,
                  validator: (value) {
                    return (value != null && value.length >= 9)
                        ? null
                        : 'Debe contener 9 caracteres';
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  autocorrect: false,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecorations.authInputDecoration(
                      color: Colors.grey[350]!,
                      hintText: 'Mínimo 9 caracteres',
                      labelText: 'Confirmar Contraseña',
                      prefixIcon: Icons.lock_outlined),
                  onChanged: (value) => registerForm.confirmPassword = value,
                  validator: (value) {
                    return (value != null &&
                            value.length >= 9 &&
                            value == registerForm.password)
                        ? null
                        : 'Las contraseñas no coinciden';
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        MaterialButton(
          onPressed: registerForm.isLoading
              ? null
              : () async {
                  if (!registerForm.isValidForm()) return;
                  registerForm.isLoading = true;
                  FocusScope.of(context).unfocus();

                  //hacer la peticion al backend para validar usuario
                  final authService =
                      Provider.of<AuthService>(context, listen: false);
                  final bool? result = await authService.registerUser(
                    registerForm.name,
                    registerForm.lastName,
                    registerForm.email,
                    registerForm.phone,
                    registerForm.password,
                  );

                  if (result != null && !result) {
                    print(
                        'No se registro: ${registerForm.name}, ${registerForm.lastName}, ${registerForm.email}, ${registerForm.password}, ${registerForm.phone},');

                    // Notifications.showSnackBar(result.toString());
                    registerForm.isLoading = false;
                    return;
                  }

                  oneSignalProvider.saveUpdateId();
                  registerForm.isLoading = false;
                  Future.microtask(
                    () {
                      Navigator.pushReplacementNamed(
                        context,
                        Home.routeName,
                      );
                    },
                  );
                },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          disabledColor: Colors.grey,
          elevation: 0,
          minWidth: size.width * 0.8,
          color: myColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Text(
              registerForm.isLoading ? 'Espere' : 'Registrarme',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿Ya tienes cuenta?',
              style: TextStyle(
                color: Preferences.isDarkMode
                    ? ThemeProvider.white
                    : ThemeProvider.darkColor,
              ),
            ),
            TextButton(
                onPressed: () => Navigator.pushReplacementNamed(
                      context,
                      LoginScreen.routeName,
                    ),
                child: const Text(
                  'inicia sesión',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                )),
          ],
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}

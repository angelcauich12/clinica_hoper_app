import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/services.dart';
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
    final size = MediaQuery.of(context).size;
    final oneSignalProvider = Provider.of<OneSignalProvider>(context);
    final googleApiService = Provider.of<GoogleSignInAPiService>(context);
    oneSignalProvider.initOneSignal(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 40),
              width: double.infinity,
              height: size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: (Preferences.isDarkMode)
                      ? [ThemeProvider.darkColor]
                      : [
                          const Color(0xff126276).withAlpha(255),
                          const Color(0xff126276).withAlpha(240),
                          const Color(0xff126276).withAlpha(220),
                        ],
                ),
              ),
            ),
            Container(
              margin:
                  (size.height < 670) ? const EdgeInsets.only(top: 20) : null,
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    flex: 2,
                    child: SizedBox(),
                  ),
                  const LogoBrand(),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: Preferences.isDarkMode
                          ? ThemeProvider.darkColor
                          : ThemeProvider.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          _LoginForm(),
                          const SizedBox(height: 20),
                          (size.height < 670)
                              ? Container()
                              : Container(),
                              // OrDivider(title: 'O ingresa con'),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     SocialMediaButton(
                          //       imagePath: 'assets/images/brand/google.png',
                          //       onTap: () async {
                          //         Notifications.showSnackBar(
                          //             'Login con Google!!');
                          //       },
                          //       // onTap: () => onGoogleSignIn(context,
                          //       //     googleApiService, oneSignalProvider),
                          //     ),
                          //     const SizedBox(width: 20),
                          //     SocialMediaButton(
                          //         imagePath: 'assets/images/brand/facebook.png',
                          //         onTap: () async {
                          //           Notifications.showSnackBar(
                          //               'Login con Facebook!!');
                          //         }),
                          //     const SizedBox(width: 20),
                          //     SocialMediaButton(
                          //         imagePath: 'assets/images/brand/apple.png',
                          //         onTap: () async {
                          //           Notifications.showSnackBar(
                          //               'Login con Apple!!');
                          //         }),
                          //   ],
                          // ),
                          SizedBox(height: (size.height < 670) ? 0 : 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '¿No estás registrado?',
                                style: TextStyle(
                                  color: Preferences.isDarkMode
                                      ? ThemeProvider.white
                                      : ThemeProvider.darkColor,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                  context,
                                  RegisterScreen.routeName,
                                ),
                                child: const Text(
                                  'Crear cuenta',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

onGoogleSignIn(
    BuildContext context, googleApiService, oneSignalProvider) async {
  final user = await GoogleSignInAPiService.loginGoogle();

  print('El usuario vale ${user?.displayName}');
  if (user == null) {
    Future.microtask(
      () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LoginScreen(),
            transitionDuration: const Duration(seconds: 0),
          ),
        );
      },
    );
  } else {
    final result = await googleApiService.loginOrRegisterUser(
      user.displayName!,
      user.email,
      user.photoUrl!,
      null,
    );

    if (result != false) {
      oneSignalProvider.saveUpdateId();

      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(
        context,
        Home.routeName,
      );
    }
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    final Color myColor = ThemeProvider.secondColor;
    final oneSignalProvider = Provider.of<OneSignalProvider>(context);

    Timer(
      const Duration(seconds: 10),
      () => oneSignalProvider.setOneSignalId(),
    );

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Preferences.isDarkMode
                ? ThemeProvider.darkColor
                : ThemeProvider.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xff126276).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8)),
            ],
          ),
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
                    color: Colors.grey[350]!,
                    hintText: '999X-XXXXXX',
                    labelText: 'Correo o número de teléfono',
                    prefixIcon: Icons.phone_android_outlined,
                  ),
                  onChanged: (value) => loginForm.email = value,
                  validator: (value) {
                    String pattern =
                        // r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        r'^([0-9]{10})|([A-Za-z0-9._%\+\-]+@[a-z0-9.\-]+\.[a-z]{2,3})$';
                    RegExp regExp = RegExp(pattern);
                    return regExp.hasMatch(value ?? '')
                        ? null
                        : 'Escriba un email ó 10 digitos para teléfono.';
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
                  onChanged: (value) => loginForm.password = value,
                  validator: (value) {
                    return (value != null && value.length >= 9)
                        ? null
                        : 'Debe contener 9 caracteres';
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 30,
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
                  final String? loginMessage = await authService.loginUser(
                      loginForm.email, loginForm.password);

                  if (loginMessage != 'true') {
                    print(
                        'No se logueo: ${loginForm.email}, ${loginForm.password}');

                    Notifications.showSnackBar(loginMessage.toString());
                    loginForm.isLoading = false;
                    return;
                  }

                  oneSignalProvider.saveUpdateId();
                  loginForm.isLoading = false;
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
          minWidth: double.infinity,
          color: myColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Text(
              loginForm.isLoading ? 'Espere' : 'Iniciar Sesión',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

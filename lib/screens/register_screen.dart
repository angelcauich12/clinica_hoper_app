import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/ui/input_decorations.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = 'registro';

  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      child: const _RegisterForm(),
                    ),
                    const SizedBox(height: 10),
                    const _signInButton()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _signInButton extends StatelessWidget {
  const _signInButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(const StadiumBorder()),
      ),
      onPressed: () => Navigator.pushReplacementNamed(
        context,
        LoginScreen.routeName,
      ),
      child: Text(
        '¿Ya tienes una cuenta?',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
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
    final width80 = (size.width * 0.15);
    final loginForm = Provider.of<LoginFormProvider>(context);
    final Color myColor = ThemeProvider.blueColor;

    return Container(
      child: Form(
          key: loginForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration: InputDecorations.authInputDecoration(
                    color: myColor,
                    hintText: 'John Doe',
                    labelText: 'Nombre',
                    prefixIcon: Icons.person_pin_outlined),
                onChanged: (value) => loginForm.email = value,
                validator: (value) {
                  return (value != null && value.length >= 3)
                      ? null
                      : 'Nombre debe contener más de 3 caracteres.';
                },
              ),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    color: myColor,
                    hintText: 'john.doe@mail.com',
                    labelText: 'Email',
                    prefixIcon: Icons.alternate_email_outlined),
                onChanged: (value) => loginForm.email = value,
                validator: (value) {
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
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecorations.authInputDecoration(
                    color: myColor,
                    hintText: 'Mínimo 8 caracteres',
                    labelText: 'Contraseña',
                    prefixIcon: Icons.lock_outlined),
                onChanged: (value) => loginForm.password = value,
                validator: (value) {
                  return (value != null && value.length >= 8)
                      ? null
                      : 'Contraseña inválida.';
                },
              ),
              const SizedBox(
                height: 15,
              ),
              MaterialButton(
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        if (!loginForm.isValidForm()) return;
                        loginForm.isLoading = true;
                        FocusScope.of(context).unfocus();
                        await Future.delayed(const Duration(seconds: 2));

                        loginForm.isLoading = false;

                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacementNamed(context, Home.routeName);
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
                    loginForm.isLoading ? 'Espere' : 'Regístrame',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          )),
    );
  }
}

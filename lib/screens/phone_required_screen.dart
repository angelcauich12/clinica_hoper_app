import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/ui/input_decorations.dart';
import 'package:provider/provider.dart';

class PhoneRequiredScreen extends StatelessWidget {
  static const String routeName = 'phone_required';

  @override
  Widget build(BuildContext context) {
    final googleApiService = Provider.of<GoogleSignInAPiService>(context);
    final registerForm = Provider.of<SocialMediaFormProvider>(context);
    final Color myColor = ThemeProvider.thirdColor;
    final size = MediaQuery.of(context).size;

    final authData =
        ModalRoute.of(context)!.settings.arguments as AuthDataRequest?;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeProvider.secondColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Teléfono Requerido',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            color: ThemeProvider.white,
          ),
        ),
        actions: const [
          // PopupMenuList(),
        ],
      ),
      // backgroundColor: ThemeProvider.secondColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (authData?.image == null)
                ? const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/user-icon.png'),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                      placeholder: const AssetImage('assets/loading.gif'),
                      image: NetworkImage(authData!.image),
                    ),
                  ),
            const SizedBox(height: 15),
            Text(
              '${authData?.name}',
              style: TextStyle(
                color: ThemeProvider.thirdColor,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${authData?.email}',
              style: TextStyle(
                color: ThemeProvider.thirdColor,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            Container(
              width: size.width * 0.7,
              child: Form(
                key: registerForm.socialMediaFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      textAlign: TextAlign.center,
                      autocorrect: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      decoration: InputDecorations.authInputDecoration(
                        color: myColor,
                        hintText: 'XXXX-XXXXXX',
                        labelText: 'Celular',
                        // prefixIcon: Icons.phone,
                      ),
                      onChanged: (value) => registerForm.phone = value,
                      validator: (value) {
                        return (value != null && value.length == 10)
                            ? null
                            : 'Debe contener 10 números.';
                      },
                    ),
                    const SizedBox(height: 15),
                    MaterialButton(
                      onPressed: registerForm.isLoading
                          ? null
                          : () async {
                              if (!registerForm.isValidForm()) return;
                              googleApiService.isLoading = true;
                              FocusScope.of(context).unfocus();

                              //hacer la peticion al backend para validar usuario
                              final result =
                                  await googleApiService.loginOrRegisterUser(
                                authData!.name,
                                authData.email,
                                authData.image,
                                registerForm.phone,
                              );

                              if (result == true) {
                                // ignore: use_build_context_synchronously
                                print(
                                    '*************************** TODO EXCELENTE ***********************');
                                Future.microtask(
                                  () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      Home.routeName,
                                    );
                                  },
                                );
                              }
                            },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      disabledColor: Colors.grey,
                      elevation: 0,
                      color: ThemeProvider.secondColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Text(
                          googleApiService.isLoading
                              ? 'Registrando'
                              : 'Regístrarme',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Salir'),
            ),
          ],
        ),
      ),
    );
  }
}

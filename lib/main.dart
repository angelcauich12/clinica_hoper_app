import 'package:flutter/material.dart';
import 'package:hope_app/locator.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:provider/provider.dart';
import 'services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  setupLocator();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider<GoogleSignInAPiService>(
          create: (context) => GoogleSignInAPiService(),
        ),
        ChangeNotifierProvider<RegisterFormProvider>(
          create: (context) => RegisterFormProvider(),
        ),
        ChangeNotifierProvider<CreateUserFormProvider>(
          create: (context) => CreateUserFormProvider(),
        ),
        ChangeNotifierProvider<SocialMediaFormProvider>(
          create: (context) => SocialMediaFormProvider(),
        ),
        ChangeNotifierProvider<CancelAppointmentFormProvider>(
          create: (context) => CancelAppointmentFormProvider(),
        ),
        ChangeNotifierProvider<LoginFormProvider>(
          create: (context) => LoginFormProvider(),
        ),
        ChangeNotifierProvider<ActivationService>(
          create: (context) => ActivationService(),
        ),
        ChangeNotifierProvider<OneSignalProvider>(
          create: (context) => OneSignalProvider(),
        ),
        ChangeNotifierProvider<NavbarProvider>(
          create: (context) => NavbarProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) =>
              ThemeProvider(isDarkmode: Preferences.isDarkMode),
        ),
        ChangeNotifierProvider<ModulosProvider>(
          create: (context) => ModulosProvider(),
          // lazy: false,
        ),
        ChangeNotifierProvider<ModuleScreenProvider>(
          create: (context) => ModuleScreenProvider(),
        ),
        ChangeNotifierProvider<MedicalRecordsProvider>(
          create: (context) => MedicalRecordsProvider(),
        ),
        ChangeNotifierProvider<MedRecordsForm1Provider>(
          create: (context) => MedRecordsForm1Provider(),
        ),
        ChangeNotifierProvider<MedRecordsForm2Provider>(
          create: (context) => MedRecordsForm2Provider(),
        ),
        ChangeNotifierProvider<MedRecordsForm3Provider>(
          create: (context) => MedRecordsForm3Provider(),
        ),
        ChangeNotifierProvider<AppointmentProvider>(
          create: (context) => AppointmentProvider(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: locator<NavigationService>().navigatorKey,
      scaffoldMessengerKey: Notifications.messengerKey,
      title: 'Clínica Hoper',
      initialRoute: ActivationScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        Home.routeName: (context) => const Home(),
        AuthTokenScreen.routeName: (context) => const AuthTokenScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        AboutScreen.routeName: (context) => const AboutScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        ActivationScreen.routeName: (context) => const ActivationScreen(),
        PhoneRequiredScreen.routeName: (context) => PhoneRequiredScreen(),
        NotificationScreen.routeName: (context) => NotificationScreen(),
        DoctorScreen.routeName: (context) => DoctorScreen(),
        SpecialtyDetailsScreen.routeName: (context) => SpecialtyDetailsScreen(),
        AppointmentDetailsScreen.routeName: (context) =>
            AppointmentDetailsScreen(),
        AppointmentUpdateScreen.routeName: (context) =>
            AppointmentUpdateScreen(),
        CreateAppointmentScreen.routeName: (context) =>CreateAppointmentScreen(),
        CreateAppointmentScreen2.routeName:(context) => CreateAppointmentScreen2(),
        MyAppointmentsScreen.routeName: (context) =>
            const MyAppointmentsScreen(),
        MedicalRecordsScreen.routeName: (context) => MedicalRecordsScreen(),
        UnderConstructionScreen.routeName: (context) =>
            const UnderConstructionScreen(),
      },
      theme: Provider.of<ThemeProvider>(context).currentTheme,
    );
  }
}

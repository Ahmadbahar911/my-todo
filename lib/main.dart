import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:finalproject_pmoif20c_alif/bloc/connectivity/connectivity_cubit.dart';
import 'package:finalproject_pmoif20c_alif/presentation/screens/my_homepage.dart';
import 'package:finalproject_pmoif20c_alif/presentation/screens/signup_page.dart';
import 'package:finalproject_pmoif20c_alif/presentation/screens/login_page.dart';
import 'package:finalproject_pmoif20c_alif/presentation/widgets/myindicator.dart';
import 'package:finalproject_pmoif20c_alif/shared/constants/consts_variables.dart';
import 'package:finalproject_pmoif20c_alif/shared/route.dart';
import 'package:finalproject_pmoif20c_alif/shared/styles/themes.dart';

import 'bloc/auth/authentication_cubit.dart';

Widget _defaultHome = const LoginPage();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic tests',
        importance: NotificationImportance.High,
        channelShowBadge: true,
        locked: false,
      ),
    ],
  );

  final prefs = await SharedPreferences.getInstance();
  final bool? seen = prefs.getBool('seen');
  profileimagesindex = prefs.getInt('plogo') ?? 0;
  runApp(
    MyApp(
      seen: seen,
      approute: AppRoute(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.approute, required this.seen})
      : super(key: key);

  final AppRoute approute;
  final bool? seen;

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation, deviceType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
                lazy: false,
                create: (context) =>
                    ConnectivityCubit()..initializeConnectivity()),
           
            BlocProvider(create: (context) => AuthenticationCubit()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Todo App',
            themeMode: ThemeMode.light,
            theme: MyTheme.lightTheme,
            darkTheme: MyTheme.darkTheme,
            onGenerateRoute: approute.generateRoute,
            //home: StreamBuilder<User?>(
             // stream: FirebaseAuth.instance.authStateChanges(),
              //builder: (context, snapshot) {
             //   if (snapshot.connectionState == ConnectionState.waiting) {
              //    return const MyCircularIndicator();
               // }
               // if (snapshot.hasData) {
               //   return const MyHomePage();
               // }
               // if (seen != null) {
               //   return const WelcomePage();
               // }
               // return const OnboardingPage();
              //},
             routes: {
              '/': (context) => _defaultHome,
              '/home': (context) =>  const MyHomePage(),
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegisterPage(),
              },
            //),
          ),
        );
      },
    );
  }
}

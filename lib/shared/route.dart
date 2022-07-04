import 'package:flutter/material.dart';
import 'package:finalproject_pmoif20c_alif/data/models/task_model.dart';
import 'package:finalproject_pmoif20c_alif/presentation/screens/addtask_screen.dart';
import 'package:finalproject_pmoif20c_alif/presentation/screens/login_page.dart';
import 'package:finalproject_pmoif20c_alif/presentation/screens/my_homepage.dart';
import 'package:finalproject_pmoif20c_alif/presentation/screens/signup_page.dart';
import 'package:finalproject_pmoif20c_alif/shared/constants/strings.dart';

class AppRoute {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginpage:
        {
          return MaterialPageRoute(builder: (_) => const LoginPage());
        }
      case signuppage:
        {
          return MaterialPageRoute(builder: (_) => const RegisterPage());
        }
      case homepage:
        {
          return MaterialPageRoute(builder: (_) => const MyHomePage());
        }
      case addtaskpage:
        {
          final task = settings.arguments as TaskModel?;
          return MaterialPageRoute(
              builder: (_) => AddTaskScreen(
                    task: task,
                  ));
        }
      default:
        throw 'No Page Found!!';
    }
  }
}

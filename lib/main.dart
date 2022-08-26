import 'package:drift_flutter/src/page/add_employee_page.dart';
import 'package:drift_flutter/src/page/home_page.dart';
import 'package:drift_flutter/src/utils/app_routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Drift Tutorial',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.addEmployee: (context) => const AddEmployeePage(),
      },
    );
  }
}

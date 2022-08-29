import 'package:drift_flutter/src/data/local/db/app_db.dart';
import 'package:drift_flutter/src/page/add_employee_page.dart';
import 'package:drift_flutter/src/page/edit_employee_page.dart';
import 'package:drift_flutter/src/page/home_page.dart';
import 'package:drift_flutter/src/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    Provider(
      create: (context) => AppDb(),
      child: const MyApp(),
      dispose: (context, AppDb db) => db.close(),
    ),
  );
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
        AppRoutes.editEmployee: (context) => const EditEmployeePage(),
      },
    );
  }
}

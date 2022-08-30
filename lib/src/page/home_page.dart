import 'package:drift_flutter/src/page/employee_future.dart';
import 'package:drift_flutter/src/page/employee_stream.dart';
import 'package:drift_flutter/src/provider/employee_provider.dart';
import 'package:drift_flutter/src/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  final pages = const [
    EmployeeFuturePage(),
    EmployeeStreamPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addEmployee);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Employee'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          if (value == 1) {
            context.read<EmployeeProvider>().getEmployeeStream();
          }
          setState(() {
            index = value;
          });
        },
        backgroundColor: Colors.blue.shade300,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white30,
        showSelectedLabels: false,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            activeIcon: Icon(Icons.list_outlined),
            label: 'Employee Future',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            activeIcon: Icon(Icons.list_outlined),
            label: 'Employee Stream',
          ),
        ],
      ),
    );
  }
}

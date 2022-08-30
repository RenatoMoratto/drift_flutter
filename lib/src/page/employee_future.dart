import 'package:drift_flutter/src/data/local/db/app_db.dart';
import 'package:drift_flutter/src/provider/employee_provider.dart';
import 'package:drift_flutter/src/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeFuturePage extends StatelessWidget {
  const EmployeeFuturePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Future"),
        centerTitle: true,
      ),
      body: Consumer<EmployeeProvider>(
        builder: (context, notifier, child) {
          if (notifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: notifier.employeeListFuture.length,
            itemBuilder: (context, index) {
              final employee = notifier.employeeListFuture[index];

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.editEmployee,
                    arguments: employee,
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 12.0,
                  ),
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.green,
                      width: 1.2,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(employee.id.toString()),
                        Text(employee.userName.toString()),
                        Text(employee.firstName.toString()),
                        Text(employee.lastName.toString()),
                        Text(employee.dateOfBirth.toString()),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

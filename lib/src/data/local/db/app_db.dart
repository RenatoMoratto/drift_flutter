import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/src/data/local/entity/employee_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
// Comand: flutter pub run build_runner build --delete-conflicting-outputs
part 'app_db.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'employee.sqlite'));

    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Employee])
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<EmployeeData>> getEmployees() async {
    return await select(employee).get();
  }

  Stream<List<EmployeeData>> getEmployeesStream() {
    return select(employee).watch();
  }

  Future<EmployeeData> getEmployee(int id) async {
    return await (select(employee)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  Future<bool> updateEmployee(EmployeeCompanion entity) async {
    return await update(employee).replace(entity);
  }

  Future<int> insertEmployee(EmployeeCompanion entity) async {
    return await into(employee).insert(entity);
  }

  Future<int> deleteEmployee(int id) async {
    return await (delete(employee)..where((tbl) => tbl.id.equals(id))).go();
  }
}

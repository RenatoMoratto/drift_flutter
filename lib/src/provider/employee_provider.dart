import 'package:drift_flutter/src/data/local/db/app_db.dart';
import 'package:flutter/material.dart';

class EmployeeProvider extends ChangeNotifier {
  AppDb? _appDb;
  List<EmployeeData> _employeeListFuture = [];
  List<EmployeeData> _employeeListStream = [];
  String _error = '';
  bool _isAdded = false;
  bool _isUpdated = false;
  bool _isDeleted = false;
  bool _isLoading = false;

  void initAppDb(AppDb db) {
    _appDb = db;
  }

  List<EmployeeData> get employeeListFuture => [..._employeeListFuture];

  List<EmployeeData> get employeeListStream => [..._employeeListStream];

  String get error => _error;

  bool get isAdded => _isAdded;

  bool get isUpdated => _isUpdated;

  bool get isDeleted => _isDeleted;

  bool get isLoading => _isLoading;

  void getEmployeeFuture() {
    _isLoading = true;

    _appDb?.getEmployees().then((value) {
      _employeeListFuture = value;
    }).onError((error, stackTrace) {
      _error = error.toString();
    }).whenComplete(() {
      _isLoading = false;
      notifyListeners();
    });
  }

  void getEmployeeStream() {
    _isLoading = true;

    _appDb?.getEmployeesStream().listen((event) {
      _employeeListStream = event;
    }).onError((error, stackTrace) {
      _error = error.toString();
    });

    _isLoading = false;
    notifyListeners();
  }

  void createEmployee(EmployeeCompanion entity) {
    _appDb?.insertEmployee(entity).then((value) {
      _isAdded = value >= 1;
    }).onError((error, stackTrace) {
      _error = error.toString();
    }).whenComplete(() {
      notifyListeners();
    });
  }

  void updateEmployee(EmployeeCompanion entity) {
    _appDb?.updateEmployee(entity).then((value) {
      _isUpdated = value;
    }).onError((error, stackTrace) {
      _error = error.toString();
    }).whenComplete(() {
      notifyListeners();
    });
  }

  void deleteEmployee(int id) {
    _appDb?.deleteEmployee(id).then((value) {
      _isDeleted = value >= 1;
    }).onError((error, stackTrace) {
      _error = error.toString();
    }).whenComplete(() {
      notifyListeners();
    });
  }
}

import 'package:drift_flutter/src/components/custom_date_picker_form_field.dart';
import 'package:drift_flutter/src/components/custom_text_form_field.dart';
import 'package:drift_flutter/src/data/local/db/app_db.dart';
import 'package:drift_flutter/src/provider/employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import 'package:provider/provider.dart';

class EditEmployeePage extends StatefulWidget {
  const EditEmployeePage({Key? key}) : super(key: key);

  @override
  State<EditEmployeePage> createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, Object> _formData = {};
  final _dateOfBirthController = TextEditingController();
  DateTime? _dateOfBirth;
  late EmployeeProvider _employeeProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final employee = arg as EmployeeData;

        _formData['id'] = employee.id;
        _formData['userName'] = employee.userName;
        _formData['firstName'] = employee.firstName;
        _formData['lastName'] = employee.lastName;
        _formData['dateOfBirth'] = employee.dateOfBirth;

        _dateOfBirth = employee.dateOfBirth;
        _dateOfBirthController.text =
            DateFormat('dd/MM/yyyy').format(employee.dateOfBirth);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
    _employeeProvider.addListener(providerListener);
  }

  @override
  void dispose() {
    super.dispose();
    _dateOfBirthController.dispose();
    _employeeProvider.dispose();
  }

  void _deleteEmployee() {
    context.read<EmployeeProvider>().deleteEmployee(_formData['id'] as int);
  }

  void _editEmployee() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid || _dateOfBirth == null) {
      return;
    }

    _formKey.currentState?.save();
    final entity = EmployeeCompanion(
      id: drift.Value(_formData['id'] as int),
      userName: drift.Value(_formData['userName'] as String),
      firstName: drift.Value(_formData['firstName'] as String),
      lastName: drift.Value(_formData['lastName'] as String),
      dateOfBirth: drift.Value(_dateOfBirth!),
    );

    context.read<EmployeeProvider>().updateEmployee(entity);
  }

  void providerListener() {
    if (_employeeProvider.isUpdated) {
      listenUpdate();
    }
    if (_employeeProvider.isDeleted) {
      listenDelete();
    }
  }

  void listenDelete() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Employee deleted'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void listenUpdate() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Employee updated',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.greenAccent,
      ),
    );
  }

  Future<void> pickDateOfBirth(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (context, child) => Theme(
        data: ThemeData().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.pink,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child ?? const Text(''),
      ),
    );

    if (newDate == null) {
      return;
    }

    setState(() {
      _dateOfBirth = newDate;
      _dateOfBirthController.text = DateFormat('dd/MM/yyyy').format(newDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Employee'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _editEmployee,
            icon: const Icon(Icons.save),
          ),
          IconButton(
            onPressed: _deleteEmployee,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomTextFormField(
                initialValue: _formData['userName'].toString(),
                label: 'User Name',
                onSaved: (username) => _formData['userName'] = username ?? '',
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                initialValue: _formData['firstName'].toString(),
                label: 'First Name',
                onSaved: (firstName) =>
                    _formData['firstName'] = firstName ?? '',
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                initialValue: _formData['lastName'].toString(),
                label: 'Last Name',
                onSaved: (lastName) => _formData['lastName'] = lastName ?? '',
              ),
              const SizedBox(height: 8),
              CustomDatePickerFormField(
                label: 'Date of Birth',
                controller: _dateOfBirthController,
                callback: () => pickDateOfBirth(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

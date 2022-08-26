import 'package:drift_flutter/src/components/custom_date_picker_form_field.dart';
import 'package:drift_flutter/src/components/custom_text_form_field.dart';
import 'package:drift_flutter/src/data/local/db/app_db.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({Key? key}) : super(key: key);

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  late AppDb _db;
  final _formKey = GlobalKey<FormState>();
  final Map<String, Object> _formData = {};
  final _dateOfBirthController = TextEditingController();
  DateTime? _dateOfBirth;

  @override
  initState() {
    super.initState();
    _db = AppDb();
  }

  @override
  void dispose() {
    super.dispose();
    _db.close();
    _dateOfBirthController.dispose();
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid || _dateOfBirth == null) {
      return;
    }

    _formKey.currentState?.save();
    final entity = EmployeeCompanion(
      userName: drift.Value(_formData['userName'] as String),
      firstName: drift.Value(_formData['firstName'] as String),
      lastName: drift.Value(_formData['lastName'] as String),
      dateOfBirth: drift.Value(_dateOfBirth!),
    );

    _db.insertEmployee(entity).then(
          (value) => ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              content: Text('New employee inserted: $value'),
              actions: [
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
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
        title: const Text('Add Employee'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
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
                label: 'User Name',
                onSaved: (username) => _formData['userName'] = username ?? '',
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                label: 'First Name',
                onSaved: (firstName) =>
                    _formData['firstName'] = firstName ?? '',
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
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

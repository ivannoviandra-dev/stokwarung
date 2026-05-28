import 'package:flutter/material.dart';
import '../models/employee_model.dart';

/// Employee management provider.
class EmployeeProvider extends ChangeNotifier {
  List<Employee> _employees = [];
  bool _isLoading = false;

  List<Employee> get employees => _employees;
  bool get isLoading => _isLoading;

  int get activeCount => _employees.where((e) => e.isActive).length;
  int get totalCount => _employees.length;

  Future<void> loadEmployees() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _employees = Employee.sampleEmployees();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addEmployee(Employee employee) async {
    _employees.add(employee);
    notifyListeners();
  }

  Future<void> updateEmployee(Employee employee) async {
    final index = _employees.indexWhere((e) => e.id == employee.id);
    if (index != -1) {
      _employees[index] = employee;
      notifyListeners();
    }
  }

  Future<void> toggleEmployeeStatus(String employeeId) async {
    final index = _employees.indexWhere((e) => e.id == employeeId);
    if (index != -1) {
      _employees[index] = _employees[index].copyWith(
        isActive: !_employees[index].isActive,
      );
      notifyListeners();
    }
  }

  Future<void> removeEmployee(String employeeId) async {
    _employees.removeWhere((e) => e.id == employeeId);
    notifyListeners();
  }
}

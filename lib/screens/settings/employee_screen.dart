import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/employee_model.dart';
import '../../providers/employee_provider.dart';
import '../../utils/snackbar_helper.dart';
import '../../utils/validators.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/empty_state.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedRole = 'Kasir';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeeProvider>().loadEmployees();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showAddEmployeeDialog(BuildContext context, EmployeeProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Tambah Karyawan Baru'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTextField(
                      label: 'Nama Karyawan',
                      hint: 'Contoh: Ahmad Subardjo',
                      controller: _nameController,
                      validator: (val) => Validators.required(val, 'Nama karyawan'),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Nomor Telepon',
                      hint: '08xxxxxxxxxx',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: Validators.phone,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedRole,
                      decoration: const InputDecoration(
                        labelText: 'Peran / Hak Akses',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      items: ['Kasir', 'Admin'].map((r) {
                        return DropdownMenuItem(value: r, child: Text(r));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            _selectedRole = val;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _nameController.clear();
                    _phoneController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Batal'),
                ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: context.appColors.primary),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      provider.addEmployee(
                        Employee(
                          id: 'E${DateTime.now().millisecondsSinceEpoch}',
                          name: _nameController.text.trim(),
                          role: _selectedRole,
                          phone: _phoneController.text.trim(),
                        ),
                      );
                      SnackbarHelper.showSuccess(context, 'Karyawan berhasil didaftarkan');
                      _nameController.clear();
                      _phoneController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Tambah'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final employeeProvider = context.watch<EmployeeProvider>();
    final list = employeeProvider.employees;

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: const Text('Kelola Karyawan'),
      ),
      body: employeeProvider.isLoading
          ? Center(child: CircularProgressIndicator(color: context.appColors.primary))
          : list.isEmpty
              ? EmptyState(
                  icon: Icons.people_outline,
                  title: 'Belum ada karyawan',
                  description: 'Daftarkan admin atau kasir untuk membantu operasional warung Anda.',
                  actionLabel: 'Tambah Karyawan',
                  onActionPressed: () => _showAddEmployeeDialog(context, employeeProvider),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final emp = list[index];
                    return AppCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      accentColor: emp.isActive ? context.appColors.primary : context.appColors.secondary,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: context.appColors.surfaceContainerLow,
                            child: Icon(Icons.person, color: context.appColors.primary),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      emp.name,
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: emp.isActive ? context.appColors.textPrimary : context.appColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    StatusChip(
                                      label: emp.role,
                                      type: emp.role == 'Admin' ? StatusChipType.success : StatusChipType.neutral,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(emp.phone, style: textTheme.bodySmall),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Switch(
                                value: emp.isActive,
                                activeThumbColor: context.appColors.primary,
                                onChanged: (val) {
                                  employeeProvider.toggleEmployeeStatus(emp.id);
                                  SnackbarHelper.showInfo(
                                    context,
                                    val ? 'Akses ${emp.name} diaktifkan' : 'Akses ${emp.name} dinonaktifkan',
                                  );
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  employeeProvider.removeEmployee(emp.id);
                                  SnackbarHelper.showSuccess(context, 'Karyawan dihapus');
                                },
                                child: Icon(Icons.delete_outline, size: 18, color: context.appColors.error),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: list.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _showAddEmployeeDialog(context, employeeProvider),
              backgroundColor: context.appColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/core/di/injection.dart';
import 'package:wemu_team_app/features/profile/domain/usecases/change_password_usecase.dart';
import 'package:wemu_team_app/features/profile/presentation/bloc/change_password_cubit.dart';
import 'package:wemu_team_app/features/profile/presentation/bloc/change_password_state.dart';
import 'package:wemu_team_app/widgets/button/basic_button.dart';
import 'package:wemu_team_app/widgets/input/field_input.dart';

class PinPasswordPage extends StatefulWidget {
  const PinPasswordPage({super.key});

  @override
  State<PinPasswordPage> createState() => _PinPasswordPageState();
}

class _PinPasswordPageState extends State<PinPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;

  late final ChangePasswordCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ChangePasswordCubit(getIt<ChangePasswordUseCase>());
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state.status == ChangePasswordStatus.failure) {
            final msg = state.errorMessage ?? 'Change password failed.';
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
          }
          if (state.status == ChangePasswordStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password Change Successful!')),
            );
            _currentPasswordController.clear();
            _newPasswordController.clear();
            _cubit.reset();
          }
        },
        builder: (context, state) {
          final cubit = context.read<ChangePasswordCubit>();
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
              centerTitle: false,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 18),
                      FieldInput(
                        label: 'Current Password',
                        hintText: 'Enter current password',
                        controller: _currentPasswordController,
                        obscureText: _obscureCurrentPassword,
                        validator: (v) {
                          if ((v ?? '').isEmpty) return 'Current password is required';
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscureCurrentPassword = !_obscureCurrentPassword),
                          icon: Icon(
                            _obscureCurrentPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FieldInput(
                        label: 'New Password',
                        hintText: 'Enter new password',
                        controller: _newPasswordController,
                        obscureText: _obscureNewPassword,
                        validator: (v) {
                          final text = v ?? '';
                          if (text.isEmpty) return 'New password is required';
                          if (text.length < 6) return 'Password must be at least 6 characters';
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                          icon: Icon(
                            _obscureNewPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      BasicButton(
                        title: state.isLoading ? 'Saving...' : 'Save',
                        height: 50,
                        onPressed: () {
                          if (state.isLoading) return;
                          final ok = _formKey.currentState?.validate() ?? false;
                          if (!ok) return;
                          cubit.submit(
                            currentPassword: _currentPasswordController.text,
                            newPassword: _newPasswordController.text,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


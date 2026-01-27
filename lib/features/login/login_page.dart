import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wemu_team_app/generated/localizations.dart';
import 'package:wemu_team_app/core/di/injection.dart';
import 'package:wemu_team_app/widgets/button/basic_button.dart';
import 'package:wemu_team_app/core/configs/assets/app_images.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/widgets/input/field_input.dart';
import 'package:wemu_team_app/features/main/main_page.dart';
import 'package:wemu_team_app/features/login/presentation/bloc/login_cubit.dart';
import 'package:wemu_team_app/features/login/presentation/bloc/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final LoginCubit _cubit;
  bool _didAutofill = false;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<LoginCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.loadSavedCredentials();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _submit(LoginCubit cubit) {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    cubit.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      rememberMe: _rememberMe,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (!_didAutofill &&
              state.savedEmail != null &&
              _emailController.text.isEmpty &&
              _passwordController.text.isEmpty) {
            _emailController.text = state.savedEmail!;
            _passwordController.text = state.savedPassword ?? '';
            setState(() => _rememberMe = true);
            _didAutofill = true;
          }
          if (state.status == LoginStatus.failure) {
            final message = state.errorMessage ?? l10n.loginErrorGeneric;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
          }
          if (state.status == LoginStatus.success) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) => const MainPage()),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<LoginCubit>();

          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                // Background (same as Intro)
                Positioned.fill(child: Image.asset(AppImages.introBG, fit: BoxFit.cover)),

                // Overlay (same as Intro)
                Positioned.fill(child: Container(color: AppColors.introOverlay)),

                // Content
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 24),

                            // Logo
                            Align(
                              alignment: Alignment.topCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'TRIP',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary, // Teal color
                                    ),
                                  ),
                                  const Text(
                                    'in',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Title
                            Text(
                              l10n.loginTitle,
                              style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.w800),
                            ),

                            const SizedBox(height: 20),

                            // Email
                            FieldInput(
                              label: l10n.loginEmailLabel,
                              labelColor: AppColors.white,
                              hintText: l10n.loginEmailHint,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                final text = value?.trim() ?? '';
                                if (text.isEmpty) {
                                  return l10n.loginEmailRequired;
                                }
                                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                                if (!emailRegex.hasMatch(text)) {
                                  return l10n.loginEmailInvalid;
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Password
                            FieldInput(
                              label: l10n.loginPasswordLabel,
                              labelColor: AppColors.white,
                              hintText: l10n.loginPasswordHint,
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              validator: (value) {
                                final text = value ?? '';
                                if (text.isEmpty) {
                                  return l10n.loginPasswordRequired;
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    setState(() => _obscurePassword = !_obscurePassword),
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Remember + Forgot
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (v) => setState(() => _rememberMe = v ?? false),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  side: const BorderSide(color: AppColors.white, width: 1),
                                  fillColor: MaterialStateProperty.resolveWith((states) {
                                    if (states.contains(MaterialState.selected)) {
                                      return AppColors.primary;
                                    }
                                    return Colors.transparent;
                                  }),
                                ),
                                Text(l10n.loginRememberMe, style: const TextStyle(color: Colors.white)),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    l10n.loginForgotPassword,
                                    style: const TextStyle(
                                      color: AppColors.blue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            // Sign in button
                            BasicButton(
                              title: state.isLoading ? l10n.loginSigningIn : l10n.loginSignIn,
                              height: 50,
                              onPressed: () => _submit(cubit),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

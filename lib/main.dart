import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wemu_team_app/generated/localizations.dart';
import 'package:wemu_team_app/core/di/injection.dart';
import 'package:wemu_team_app/core/configs/theme/app_theme.dart';
import 'package:wemu_team_app/features/intro/intro_page.dart';
import 'package:wemu_team_app/features/login/domain/repositories/auth_repository.dart';
import 'package:wemu_team_app/features/main/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const _AuthGate(),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final token = getIt<AuthRepository>().getCachedToken();
    final user = getIt<AuthRepository>().getCachedUser();
    final permissions = getIt<AuthRepository>().getCachedPermissions();
    if (token != null && token.isNotEmpty && user != null && permissions.isNotEmpty) {
      return const MainPage();
    }
    return const IntroPage();
  }
}

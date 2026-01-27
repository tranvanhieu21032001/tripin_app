// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'Login';

  @override
  String get loginEmailLabel => 'Email Address';

  @override
  String get loginEmailHint => 'Enter your email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHint => 'Enter your password';

  @override
  String get loginRememberMe => 'Remember Me';

  @override
  String get loginForgotPassword => 'Forgot Password?';

  @override
  String get loginSignIn => 'Sign In';

  @override
  String get loginSigningIn => 'Signing In...';

  @override
  String get loginEmailRequired => 'Email is required';

  @override
  String get loginEmailInvalid => 'Invalid email';

  @override
  String get loginPasswordRequired => 'Password is required';

  @override
  String get loginErrorGeneric => 'Login failed. Please try again.';

  @override
  String get homeGreetingMorning => 'Good Morning,';

  @override
  String get homeGreetingAfternoon => 'Good Afternoon,';

  @override
  String get homeGreetingEvening => 'Good Evening,';

  @override
  String get homeGreetingDefault => 'Hello,';
}

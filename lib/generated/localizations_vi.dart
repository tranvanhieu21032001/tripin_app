// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get loginTitle => 'Dang nhap';

  @override
  String get loginEmailLabel => 'Dia chi email';

  @override
  String get loginEmailHint => 'Nhap email cua ban';

  @override
  String get loginPasswordLabel => 'Mat khau';

  @override
  String get loginPasswordHint => 'Nhap mat khau cua ban';

  @override
  String get loginRememberMe => 'Ghi nho dang nhap';

  @override
  String get loginForgotPassword => 'Quen mat khau?';

  @override
  String get loginSignIn => 'Dang nhap';

  @override
  String get loginSigningIn => 'Dang dang nhap...';

  @override
  String get loginEmailRequired => 'Can nhap email';

  @override
  String get loginEmailInvalid => 'Email khong hop le';

  @override
  String get loginPasswordRequired => 'Can nhap mat khau';

  @override
  String get loginErrorGeneric => 'Dang nhap that bai. Vui long thu lai.';

  @override
  String get homeGreetingMorning => 'Chao buoi sang,';

  @override
  String get homeGreetingAfternoon => 'Chao buoi chieu,';

  @override
  String get homeGreetingEvening => 'Chao buoi toi,';

  @override
  String get homeGreetingDefault => 'Xin chao,';
}

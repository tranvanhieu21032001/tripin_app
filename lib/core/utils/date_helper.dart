import 'package:intl/intl.dart';

class DateHelper {
  DateHelper._();
  static String formatChatTimestamp(DateTime dateTime) {
    final local = dateTime.toLocal();
    return DateFormat('MMM d, yyyy h:mm a').format(local);
  }
}



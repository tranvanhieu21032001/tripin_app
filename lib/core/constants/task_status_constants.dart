class TaskStatusConstants {
  static const String completed = 'completed';
  static const String inProgress = 'inProgress';
  static const String canceled = 'canceled';
  static const String pending = 'pending';
  static const String review = 'review';

  static const Map<String, String> statusText = {
    completed: 'Completed',
    inProgress: 'In-Progress',
    canceled: 'Cancelled',
    pending: 'Pending',
    review: 'Review',
  };

  static const Map<String, int> statusBackgroundColors = {
    completed: 0xFFE5F8D6, // #E5F8D6
    inProgress: 0xFFD1EEFF, // #D1EEFF
    canceled: 0xFFF9DCE6, // #F9DCE6
    pending: 0xFFFEF4CB, // #FEF4CB
    review: 0xFFF0F0F0, // #F0F0F0
  };

  static const Map<String, int> statusBorderColors = {
    completed: 0xFFA4CF80, // #A4CF80
    inProgress: 0xFF64B7E8, // #64B7E8
    canceled: 0xFFFF90B7, // #FF90B7
    pending: 0xFFCDBF86, // #CDBF86
    review: 0xFFB0B0B0, // #B0B0B0
  };

  static String getStatusText(String status) {
    return statusText[status] ?? status;
  }

  static int getStatusBackgroundColor(String status) {
    return statusBackgroundColors[status] ?? 0xFFF0F0F0;
  }

  static int getStatusBorderColor(String status) {
    return statusBorderColors[status] ?? 0xFFB0B0B0;
  }

  static const List<String> allStatuses = [
    completed,
    inProgress,
    canceled,
    pending,
    review,
  ];
}

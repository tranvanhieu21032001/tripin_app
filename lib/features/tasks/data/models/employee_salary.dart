class EmployeeSalary {
  final String name;
  final int hours;
  final int deductions;
  final int overtime;
  final double total;
  final String currency;

  const EmployeeSalary({
    required this.name,
    required this.hours,
    required this.deductions,
    required this.overtime,
    required this.total,
    required this.currency,
  });

  factory EmployeeSalary.fromJson(Map<String, dynamic> json) {
    return EmployeeSalary(
      name: json['name'] ?? '',
      hours: json['hours'] ?? 0,
      deductions: json['deductions'] ?? 0,
      overtime: json['overtime'] ?? 0,
      total: (json['total'] ?? 0).toDouble(),
      currency: json['currency'] ?? '',
    );
  }
}

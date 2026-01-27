class TaskSummary {
  final double earnings; // totalServiceCommission
  final int totalServices; // numberOfService
  final int numberOfTransactions; // numberOfTransaction

  const TaskSummary({
    required this.earnings,
    required this.totalServices,
    required this.numberOfTransactions,
  });

  factory TaskSummary.fromJson(Map<String, dynamic> json) {
    return TaskSummary(
      earnings: (json['totalServiceCommission'] ?? 0.0).toDouble(),
      totalServices: (json['numberOfService'] ?? 0).toInt(),
      numberOfTransactions: (json['numberOfTransaction'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalServiceCommission': earnings,
      'numberOfService': totalServices,
      'numberOfTransaction': numberOfTransactions,
    };
  }
}


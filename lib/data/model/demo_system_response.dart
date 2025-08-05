class DemoSystemResponse {
  final double ss1;
  final double ss2;
  final bool succeeded;

  DemoSystemResponse({
    required this.ss1,
    required this.ss2,
    required this.succeeded,
  });

  factory DemoSystemResponse.fromJson(Map<String, dynamic> json) {
    return DemoSystemResponse(
      ss1: (json['SS1'] as num).toDouble(),
      ss2: (json['SS2'] as num).toDouble(),
      succeeded: json['Succeeded'],
    );
  }
}

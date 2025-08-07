class ArmSystemResponse {
  final bool succeeded;
  final int customErrorCode;

  ArmSystemResponse({required this.succeeded, required this.customErrorCode});

  factory ArmSystemResponse.fromJson(Map<String, dynamic> json) {
    return ArmSystemResponse(
      succeeded: json['Succeeded'] ?? false,
      customErrorCode: json['CustomErrorCode'] ?? -1,
    );
  }
}

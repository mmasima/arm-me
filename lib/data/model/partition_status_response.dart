class PartitionStatusResponse {
  final bool awayArmed;

  PartitionStatusResponse({required this.awayArmed});

  factory PartitionStatusResponse.fromJson(Map<String, dynamic> json) {
    return PartitionStatusResponse(
      awayArmed: json['AwayArmed'] as bool,
    );
  }
}

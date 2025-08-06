class PartitionStatusResponse {
  final bool awayArmed;
  final bool stayArmed;
  final bool exitDelay;
  final bool alarmed;
  final bool otherAlarmed;

  PartitionStatusResponse({
    required this.awayArmed,
    required this.stayArmed,
    required this.exitDelay,
    required this.alarmed,
    required this.otherAlarmed,
  });

  factory PartitionStatusResponse.fromJson(Map<String, dynamic> json) {
    return PartitionStatusResponse(
      awayArmed: json['AwayArmed'] ?? false,
      stayArmed: json['StayArmed1'] ?? false,
      exitDelay: json['ExitDelay'] ?? false,
      alarmed: json['Alarmed'] ?? false,
      otherAlarmed: json['OtherAlarmed'] ?? false,
    );
  }
}

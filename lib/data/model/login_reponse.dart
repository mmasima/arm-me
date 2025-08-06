class LoginResponse {
  final String accessToken;
  final String tokenType;
  final String name;
  final int expiresIn;

  LoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.name,
    required this.expiresIn,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      name: json['name'],
      expiresIn: json['expires_in'],
    );
  }
}

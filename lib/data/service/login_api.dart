import 'package:armme/data/model/login_reponse.dart';
import 'package:dio/dio.dart';

class LoginUserApi {
  final dio = Dio();

  Future<LoginResponse> loginUser(String username, String password) async {
    final response = await dio.post(
      'https://testing.srnservices.net/token?api-version=2',
      data: {
        'grant_type': 'password',
        'username': username,
        'password': password,
        'client_secret':
            'hN1Ne!4j!2AS@#zAuMbU^iUwQwX5zXTRJ@Bf@u#ux!wmY5Tl16@WMA^dEy01eqZq',
        'client_id': 'test',
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(response.data);
    } else {
      throw Exception('Login failed');
    }
  }
}

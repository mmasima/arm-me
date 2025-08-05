import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/demo_system_response.dart';
import '../model/partition_status_response.dart';

class DemoSystemApi {
  final Dio dio = Dio();

  // Shared request body
  final Map<String, dynamic> _requestBody = {
    "Partition": 1,
    "CL": "TESTBOARD",
    "AC": "39126",
    "PanelCode": "1234",
    "MobileClientId": "Test",
    "SessionId": "yourname_assessment",
  };

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _getToken();
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }

  Future<DemoSystemResponse> openConnection() async {
    final headers = await _getAuthHeaders();

    final response = await dio.post(
      'https://testing.srnservices.net/api/v2/DemoSystem/Open',
      data: _requestBody,
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      return DemoSystemResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to open demo connection');
    }
  }

  Future<PartitionStatusResponse> getPartitionStatus() async {
    final headers = await _getAuthHeaders();

    final response = await dio.post(
      'https://testing.srnservices.net/api/v2/DemoSystem/PartitionStatus',
      data: _requestBody,
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      return PartitionStatusResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to get partition status');
    }
  }
}

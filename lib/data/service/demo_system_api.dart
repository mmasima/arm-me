import 'package:armme/data/model/arm_status_response.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/demo_system_response.dart';
import '../model/partition_status_response.dart';

class DemoSystemApi {
  final Dio dio = Dio();

  final uri = 'https://testing.srnservices.net/api/v2/DemoSystem';

  Future<String?> _getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

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

  Future<Map<String, dynamic>> _buildRequestBody() async {
    final name = await _getName();
    return {
      "Partition": 1,
      "CL": "TESTBOARD",
      "AC": "39126",
      "PanelCode": "1234",
      "MobileClientId": "Test",
      "SessionId": "${name ?? 'unknown'}_assessment",
    };
  }

  Future<DemoSystemResponse> openConnection() async {
    final headers = await _getAuthHeaders();
    final body = await _buildRequestBody();

    final response = await dio.post(
      '$uri/Open',
      data: body,
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
    final body = await _buildRequestBody();

    final response = await dio.post(
      '$uri/PartitionStatus',
      data: body,
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      return PartitionStatusResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to get partition status');
    }
  }

  Future<ArmSystemResponse> setPartitionValue(String value) async {
    final headers = await _getAuthHeaders();
    final body = await _buildRequestBody();

    final response = await dio.post(
      '$uri/$value',
      data: body,
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      return ArmSystemResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to update Partition value');
    }
  }
}

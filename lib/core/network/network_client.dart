import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkClient {
  final Duration timeout;

  NetworkClient({this.timeout = const Duration(seconds: 15)});

  Future<Map<String, dynamic>> get(String url) async {
    final uri = Uri.parse(url);

    final response = await http.get(uri).timeout(timeout);

    _handleStatusCode(response);

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> post(String url, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse(url);

    final response = await http
        .post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body ?? {}),
        )
        .timeout(timeout);

    _handleStatusCode(response);

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  void _handleStatusCode(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;

    throw Exception(
      "Network error (${response.statusCode}): ${response.body}",
    );
  }
}

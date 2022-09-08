import 'package:http/http.dart' as http;
import 'dart:convert';

class GetData {
  final Uri url;
  final Map<String, String>? headers;

  GetData({required this.url, this.headers});

  Future getData() async {
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      String data = response.body;
      // print('GET: $url');
      // print(response.body);
      return jsonDecode(data);
    } else {
      // print('GET: ${response.statusCode} $url');
      // print(response.body);
    }
  }
}

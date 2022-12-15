import 'package:investing/src/constants.dart';
import '../get_data.dart';

Future<dynamic> getSingleQuote({required String code}) async {
  GetData networkHelper = GetData(
    url: Uri.parse('https://cloud.iexapis.com/stable/stock/$code/quote?token=$kIEXToken'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  var response = await networkHelper.getData();

  return response;
}

Future<dynamic> getMultipleQuote({required List<String> codes}) async {
  String stocks = codes.toSet().toList().join(","); // only different values

  GetData networkHelper = GetData(
    url: Uri.parse('https://cloud.iexapis.com/stable/stock/market/batch?symbols=$stocks&types=quote&token=$kIEXToken'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  var response = await networkHelper.getData();

  return response;
}

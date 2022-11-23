import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:untitled/modal/modal.dart';

class data_API_Helper {
  data_API_Helper._();
  static final data_API_Helper data_api_helper = data_API_Helper._();

  Future<List<json_data>?> fetchDara() async {
    String api =
        "https://projects.propublica.org/nonprofits/api/v2/search.json?order=revenue&sort_order=desc";
    http.Response res = await http.get(Uri.parse(api));

    if (res.statusCode == 200) {
      Map<String, dynamic> decodeData = jsonDecode(res.body);

      List list1 = decodeData['organizations'];

      List<json_data> list = list1.map((e) {
        return json_data.fromData(data: e);
      }).toList();

      return list;
    }
  }
}

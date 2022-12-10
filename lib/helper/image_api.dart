import 'dart:convert';

import 'package:home_service_app/modal/Image_modal.dart';
import 'package:http/http.dart' as http;

class Image_api {
  Image_api._();
  static final Image_api image_api = Image_api._();

  Future<List<Image_Modal>?> feach_Data() async {
    String uri =
        "https://pixabay.com/api/?key=30579047-59d4d724d23235f6f0ffdf3de&q=nature+people&image_type=photo&pretty=true&per_page=200";
    http.Response res = await http.get(Uri.parse(uri));

    if (res.statusCode == 200) {
      Map Json_data = jsonDecode(res.body);
      List list = Json_data['hits'];
      List<Image_Modal> Images =
          list.map((e) => Image_Modal.fromMap(data: e)).toList();

      return Images;
    }
    return null;
  }
}

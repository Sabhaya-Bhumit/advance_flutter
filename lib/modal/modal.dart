//json data

class json_data {
  int? id;
  String? name;
  String? title;
  String? location;

  json_data(
      {required this.name,
      required this.location,
      required this.title,
      required this.id});

  factory json_data.fromMap({required Map<String, dynamic> data}) {
    return json_data(
        name: data['name'],
        location: data['location'],
        title: data['title'],
        id: data['id']);
  }
  factory json_data.fromData({required Map<String, dynamic> data}) {
    return json_data(
        name: data['name'],
        location: data['city'],
        title: data['state'],
        id: data['ein']);
  }
}

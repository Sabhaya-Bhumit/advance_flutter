import 'dart:typed_data';

class student {
  int? id;
  final String name;
  final int age;
  final String course;
  Uint8List? image;

  student(
      {required this.name,
      required this.age,
      required this.course,
      this.image,
      this.id});

  factory student.fromMap({required Map<String, dynamic> data}) {
    return student(
        name: data['name'],
        age: data['age'],
        course: data['course'],
        id: data['id'],
        image: data['image']);
  }
}

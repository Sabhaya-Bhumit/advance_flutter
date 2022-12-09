import 'package:demo/modal/students_modal.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBHleper {
  DBHleper._();
  static final DBHleper dbHleper = DBHleper._();

  Database? db;

  final String dbname = "bhumit.db";
  final String StudentsTable = "student";
  final String colId = "id";
  final String colname = "name";
  final String colage = "age";
  final String colCourse = "course";
  final String colimage = "image";

  Future<void> initDB() async {
    var directoryPath = await getDatabasesPath();
    String path = join(directoryPath, dbname);

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      String query =
          "CREATE TABLE IF NOT EXISTS $StudentsTable($colId INTEGER PRIMARY KEY AUTOINCREMENT ,$colname TEXT,$colage INTEGER ,$colCourse TEXT,$colimage BLOB)";

      await db.execute(query);
    });
  }

  Future<int?> inserRecode({required student data}) async {
    await initDB();

    String query =
        "INSERT INTO $StudentsTable($colname,$colage,$colCourse,$colimage)VALUES(?,?,?,?)";

    List args = [data.name, data.age, data.course, data.image];
    int? id = await db?.rawInsert(query, args);

    return id;
  }

  Future<List<student>> fetchAllRecode() async {
    await initDB();
    String query = "SELECT * FROM $StudentsTable";

    List<Map<String, dynamic>> data = await db!.rawQuery(query);

    List<student> allStudentData =
        data.map((e) => student.fromMap(data: e)).toList();

    return allStudentData;
  }

  Future<int> deleteRecode({required int id}) async {
    await initDB();
    String query = "DELETE FROM $StudentsTable WHERE $colId=?";
    List aegs = [id];

    return db!.rawDelete(query, aegs);
  }

  Future<int> updateRecode({required student data, required int id}) async {
    await initDB();
    String query =
        "UPDATE $StudentsTable SET $colname=?, $colage=?, $colCourse=?, $colimage=? WHERE $colId=?";
    List args = [data.name, data.age, data.course, data.image, id];
    return await db!.rawUpdate(query, args);
  }

  Future<List<student>> fetchSearchedRecode({required String data}) async {
    await initDB();

    String query = "SELECT * FROM $StudentsTable WHERE $colname LIKE '%$data%'";

    List<Map<String, dynamic>> stundentData = await db!.rawQuery(query);

    List<student> allStudent =
        stundentData.map((e) => student.fromMap(data: e)).toList();

    return allStudent;
  }
}

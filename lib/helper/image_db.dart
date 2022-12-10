import 'package:home_service_app/modal/Image_modal.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Image_db {
  Image_db._();
  static final Image_db image_db = Image_db._();

  Database? db;

  final String db_name = "image.db";
  final String db_table_name = "Images";
  final String colId = "id";
  final String colImage = "image";

  Future<void> initDB() async {
    var directoryPath = await getDatabasesPath();
    String path = join(directoryPath, db_name);

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      String query =
          "CREATE TABLE IF NOT EXISTS $db_table_name($colId INTEGER PRIMARY KEY AUTOINCREMENT ,$colImage BLOB)";

      await db.execute(query);
    });
  }

  Future<void> inserRecode({required List<Image_Modal>? All_Images}) async {
    await initDB();

    All_Images?.forEach((element) async {
      String query = "INSERT INTO $db_table_name($colImage) VALUES (?)";
      List args = [element.Image];
      await db!.rawInsert(query, args);
    });
  }

  Future<List<Image_Modal>> fetchAllRecode() async {
    await initDB();
    String query = "SELECT * FROM $db_table_name";

    List<Map<String, dynamic>> data = await db!.rawQuery(query);

    List<Image_Modal> All_Images =
        data.map((e) => Image_Modal.DBMap(data: e)).toList();

    return All_Images;
  }

  Future<int>? deleteRecode() async {
    await initDB();

    String query = "DELETE FROM $db_table_name";

    return await db!.rawDelete(query);
  }
}

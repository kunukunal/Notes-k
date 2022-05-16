import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class SqliteService {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    print(path);

    return openDatabase(
      join(path, 'database12.db'),
      onCreate: (database12, version) async {
        await database12.execute('CREATE TABLE Users1(fname VARCHAR(255) NOT NULL,lname VARCHAR(255) NOT NULL)');
      },
      version: 1,
    );
  }
  //insert
  Future<int> createItem(list) async {
    // album=Album.fromJson(note);
    final Database db = await initializeDB();
    final id = await db.insert(
        'Users1', list, conflictAlgorithm: ConflictAlgorithm.fail.abort.values.replace.ignore);
    return 0;
  }
  //get data
  Future<List> getItems() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
    await db.query('Users1');
    return queryResult.map((e) => e).toList();
  }

  Future<int> updateData(String wnumber, var list) async{
    final Database db = await initializeDB();
    var result = db.update('Users1', list,where: 'fname = ?', whereArgs: [wnumber]);
    return 0;
  }

  Future<int> deleteData(String wnumber) async{
    final Database db = await initializeDB();
    int result = await db.rawDelete("DELETE FROM Users1 WHERE fname='$wnumber';");
    return 0;
  }
  Future<int> delete() async{
    final Database db = await initializeDB();
    int result = await db.rawDelete("DELETE FROM Users1;");
    return 0;
  }
}

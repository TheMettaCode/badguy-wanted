// import 'dart:io';
// import 'package:badguy/constants/app_constants.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';

// class DatabaseHelper {
//   static final _dbName = appDatabaseName;
//   static final _dbVersion = 1;
//   static final _tableName = 'wanted';

//   // making it a singleton class
//   DatabaseHelper._privateConstructor();
//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

//   Future<Database> get database async {
//     Directory directory = await getApplicationDocumentsDirectory();
//     String path = join(directory.path, _dbName);

//     Database? _database =
//         await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
        
//     return _database;
//   }

//   Future _onCreate(Database db, int version) async {
//     print('***** PROCESSING DATABASE $_tableName... *****');

//     return await db.execute('''
//     CREATE TABLE $_tableName(
//     userId INTEGER PRIMARY KEY,
//     firstName TEXT,
//     lastName TEXT,
//     userName TEXT,
//     email TEXT,
//     latitude REAL,
//     longitude REAL,
//     country TEXT,
//     countryCode TEXT,
//     region TEXT,
//     state TEXT,
//     city TEXT,
//     postalCode TEXT,
//     advertise INTEGER,
//     credits INTEGER,
//     darkTheme INTEGER,
//     termsAgreed INTEGER,
//     cautionDismissed INTEGER,
//     dev INTEGER)
//     ''');
//   }

//   Future<int> insert(Map<String, dynamic> user) async {
//     Database db = await instance.database;
//     return await db.insert(_tableName, user,
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   Future<List<Map<String, dynamic>>> queryAll() async {
//     Database db = await instance.database;
//     return await db.query(_tableName);
//   }

//   Future<Map<String, dynamic>> update(Map<String, dynamic> user) async {
//     Database db = await instance.database;
//     await db.update(_tableName, user,
//         where: 'userId = ?', whereArgs: [user['userId']]);
//     return user;
//   }

//   Future<Map<String, dynamic>> singleFieldUpdate(
//       Map<String, dynamic> user, String fieldToUpdate, dynamic newValue) async {
//     Database db = await instance.database;
//     await db.rawUpdate(
//         'UPDATE $_tableName SET $fieldToUpdate = ? WHERE userId = ?',
//         [newValue, user['userId']]);
//     return user;
//   }

//   Future<int> deleteUser(int id) async {
//     Database db = await instance.database;
//     return await db.delete(_tableName, where: 'userId = ?', whereArgs: [id]);
//   }

//   Future<void> removeDatabase() async {
//     Directory directory = await getApplicationDocumentsDirectory();
//     String path = join(directory.path, _dbName);
//     await deleteDatabase(path);
//     print('***** Database Status: Database $_dbName deleted *****');
//   }
// }

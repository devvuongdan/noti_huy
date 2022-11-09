// import 'dart:io';
// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';

// import 'models.dart';

// class AppDatabaseManager {
//   static const _dbName = "water_01.db";
//   // Use this class as a singleton
//   AppDatabaseManager._privateConstructor();
//   static final AppDatabaseManager instance =
//       AppDatabaseManager._privateConstructor();
//   static Database? _database;
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     // Instantiate the database only when it's not been initialized yet.
//     _database = await _initDatabase();
//     return _database!;
//   }

//   // Creates and opens the database.
//   _initDatabase() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, _dbName);
//     print('path: $path');
//     // await File(path).delete();
//     return await openDatabase(
//       path,
//       version: 2,
//       onCreate: _onCreate,
//     );
//   }

//   // Creates the database structure
//   // Future _onCreate(
//   //   Database db,
//   //   int version,
//   // ) async {
//   //   await db.execute('''
//   //         CREATE TABLE configs (
//   //           id TEXT PRIMARY KEY,
//   //           capacityChooserIndex INTEGER,
//   //           target INTEGER
//   //         )
//   //         ''');
//   //   await db.execute('''
//   //         CREATE TABLE logs (
//   //           id TEXT PRIMARY KEY,
//   //           capacity INTEGER,
//   //           datetime INTEGER,
//   //         )
//   //         ''');
//   //   await db.insert(
//   //     'configs',
//   //     {'id': 'default', 'capacityChooserIndex': 0, 'target': 2000},
//   //     conflictAlgorithm: ConflictAlgorithm.replace,
//   //   );
//   // }

//   Future _onCreate(
//     Database db,
//     int version,
//   ) async {
//     await db.execute('''
//           CREATE TABLE configs (
//             id TEXT PRIMARY KEY, 
//             capacityChooserIndex INTEGER,
//             target INTEGER
//           )
//           ''');
//     await db.execute('''
//           CREATE TABLE logs (
//             id TEXT PRIMARY KEY,  
//             capacity INTEGER,
//             datetime INTEGER,
//             target INTERGER
//           )
//           ''');
//     await db.insert(
//       'configs',
//       {'id': 'default', 'capacityChooserIndex': 0, 'target': 2000},
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<int> insertLog(log) async {
//     print('AppDatabaseManager: insertLog $log');
//     Database db = await database;
//     return db.insert(
//       'logs',
//       log,
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future deleteLog(String id) async {
//     print('AppDatabaseManager: deleteLog $id');
//     Database db = await database;
//     await db.delete('logs', where: 'id = ?', whereArgs: [id]);
//     print('AppDatabaseManager: deleteLog done');
//   }

//   Future<List<DailyDrinkRecord>> fetchLogs() async {
//     print('AppDatabaseManager: fetchLogs ');
//     Database db = await database;
//     List<Map<String, dynamic>> maps = await db.query('logs');
//     print('AppDatabaseManager: fetchLogs maps $maps');
//     List<DailyDrinkRecord> records = [];
//     groupBy<dynamic, String>(maps, (item) {
//       return DateFormat('dd/MM/yyyy')
//           .format(DateTime.fromMillisecondsSinceEpoch(item['datetime']));
//     }).forEach((day, logs) {
//       var _ = logs
//           .map(
//             (e) => DrinkRecord(
//               id: e['id'],
//               capacity: e['capacity'],
//               time: TimeOfDay.fromDateTime(
//                 DateTime.fromMillisecondsSinceEpoch(
//                   e['datetime'],
//                 ),
//               ),
//             ),
//           )
//           .toList();
//       records.add(DailyDrinkRecord(
//           id: 1,
//           target: 2000,
//           date: DateFormat('dd/MM/yyyy').parse(day),
//           records: _));
//     });
//     return records;
//   }

//   Future<Uploaddrinkwaterjson?> fetchConfig() async {
//     print('AppDatabaseManager: fetchConfig');
//     Database db = await database;
//     List<Map<String, dynamic>> maps = await db.query('configs');
//     print('AppDatabaseManager: fetchConfig maps $maps');
//     if (maps.isNotEmpty) {
//       return maps
//           .map((map) => Uploaddrinkwaterjson.fromJson(map))
//           .toList()
//           .first;
//     }
//     return null;
//   }

//   Future changeConfig(Map<String, dynamic> dataChanged) async {
//     print('AppDatabaseManager: changeConfig $dataChanged');
//     Database db = await database;
//     await db.update('configs', dataChanged,
//         where: 'id = ?', whereArgs: ['default']);
//     print('AppDatabaseManager: changeConfig done');
//   }

//   Future<List> fetchAll() async {
//     Database db = await database;

//     print('AppDatabaseManager: fetchConfig');
//     List<Map<String, dynamic>> maps = await db.query('configs');
//     print('AppDatabaseManager: fetchConfig maps $maps');

//     print('AppDatabaseManager: fetchLogs');
//     List<Map<String, dynamic>> maps2 = await db.query('logs');
//     print('AppDatabaseManager: fetchLogs maps $maps2');

//     return [maps, maps2];
//   }
// }

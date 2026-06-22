import 'dart:async';
import 'dart:convert';

import 'package:citron_id_card/app/core/constants/app_constants.dart';
import 'package:citron_id_card/app/modules/school/id_card/model/offline_cards_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

mixin class SqfLiteService {
  Future<void> deleteTable() async {
    String path = await getDatabasesPath();
    deleteDatabase(join(path, AppConstants.databaseName));
  }

  Future<Database> _initializeDb({OfflineCardsModel? data}) async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, AppConstants.databaseName),

      onCreate: (database, version) async {
        await database.execute('''
      CREATE TABLE ${AppConstants.tableName}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ${createColumns(data?.toJson() ?? OfflineCardsModel().toJson())}
      )
      ''');
      },

      version: 1,
    );
  }

  Future<int> insertIntoDb(OfflineCardsModel data) async {
    final db = await _initializeDb(data: data);
    return await db.insert(
      AppConstants.tableName,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<OfflineCardsModel>> getFromDb({
    required int schoolId,
  }) async {
    final db = await _initializeDb();

    final data = await db.query(
      AppConstants.tableName,
      where: 'isSynced = ? AND schoolId = ?',
      whereArgs: [0, schoolId],
    );

    return data
        .map((e) => OfflineCardsModel.fromJson(e))
        .toList();
  }

  //
  Future<int> updateSyncStatus({required int id}) async {
    final db = await _initializeDb();

    return await db.update(
      AppConstants.tableName,
      {"isSynced": 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteMultipleFromDb({
    required List<int> ids,
  }) async {
    if (ids.isEmpty) return 0;

    final db = await _initializeDb();

    return await db.delete(
      AppConstants.tableName,
      where: 'id IN (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
  }
  String createColumns(Map<dynamic, dynamic> map) {
    String column = ' ';
    map.forEach((key, value) {
      column += '$key ${getType(value.runtimeType)},';
    });
    final result = column.endsWith(',')
        ? column.substring(0, column.length - 2)
        : column;
    return result;
  }

  String getType(Type type) {
    switch (type) {
      case int:
        return "INTEGER";
      case String:
        return "TEXT";
      case double:
        return "REAL";
      case num:
        return "NUMERIC";
      case bool:
        return "BOOLEAN";
      default:
        return "TEXT";
    }
  }
}

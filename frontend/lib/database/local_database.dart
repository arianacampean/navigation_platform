import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'package:frontend/models/photo.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  static const String ID = 'id';
  static const String NAME = 'photo_name';
  static const String TABLE = 'PhotosTable';
  // static const String DB_NAME = 'photos.db';
  int id = 1;
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dont.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    WidgetsFlutterBinding.ensureInitialized();
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute("CREATE TABLE $TABLE ($ID INTEGER, $NAME TEXT)");
  }

  Future close() async {
    final data = await db.database;
    data.close();
  }

  Future<Photo> save(Photo photo) async {
    var dbClient = await db.database;
    await dbClient.insert(TABLE, photo.toMap());
    log("am facut insertul");
    return photo;
  }

  Future<Photo> changePhoto(Photo photo) async {
    var dbClient = await db.database;
    await dbClient.update(TABLE, photo.toMap(), where: 'id=?', whereArgs: [id]);
    log("updatetul");
    return photo;
  }

  Future<List<Photo>> getPhotos() async {
    var dbClient = await db.database;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME]);
    List<Photo> photos = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        photos.add(Photo.fromMap(maps[i]));
      }
    }
    return photos;
  }
}

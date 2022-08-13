import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../data/models/note.dart';
import '../data/models/note_table.dart';
import '../data/models/note_table_cell.dart';

class DatabaseService {
  static final DatabaseService _singleton = DatabaseService._internal();
  static final version = 4;

  factory DatabaseService() {
    return _singleton;
  }

  DatabaseService._internal();

  static Future<Database> initialize() async {
    String path = await getPath();
    return openDatabase(path,
        version: version, onConfigure: onConfigure, onCreate: onCreate, onUpgrade: onUpgrade, onDowngrade: onDowngrade);
  }

  static Future<String> getPath() async {
    var databasesPath = await getDatabasesPath();
    return '$databasesPath/start_note.db';
  }

  static FutureOr<void> onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON;");
  }

  static FutureOr<void> onCreate(Database db, int version) async {
    await createTables(db);
  }

  static FutureOr<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    await createTables(db);
  }

  static FutureOr<void> onDowngrade(Database db, int oldVersion, int newVersion) async {
    await dropTables(db);
    await createTables(db);
  }

  static FutureOr<void> dropTables(Database db) async {
    String dropNoteTableSql = getDropTableString(Note.tableName);
    String dropNoteTableTableSql = getDropTableString(Note.tableName);
    String dropNoteTableCellTableSql = getDropTableString(Note.tableName);

    await db.execute(dropNoteTableCellTableSql);
    await db.execute(dropNoteTableTableSql);
    await db.execute(dropNoteTableSql);
  }

  static FutureOr<void> createTables(Database db) async {
    String createNoteTableSql = getCreateTableString(Note.columnDeclarations, Note.tableName);
    String createNoteTableTableSql = getCreateTableString(NoteTable.columnDeclarations, NoteTable.tableName);
    String createNoteTableCellTableSql =
        getCreateTableString(NoteTableCell.columnDeclarations, NoteTableCell.tableName);

    await db.execute(createNoteTableSql);
    await db.execute(createNoteTableTableSql);
    await db.execute(createNoteTableCellTableSql);
  }

  static String getDropTableString(String tableName) => "DROP TABLE $tableName;";

  static String getCreateTableString(List<String> schemaList, String tableName) {
    String schemaString = "";
    schemaList.forEach((element) {
      schemaString += element + ", ";
    });
    schemaString = schemaString.substring(0, schemaString.length - 2);
    return "CREATE TABLE " + tableName + "(" + schemaString + ");";
  }
}

import 'package:logging/logging.dart';
import 'package:notime/data/models/note_table.dart';
import 'package:notime/data/repositories/_repository.dart';
import 'package:notime/services/logging_service.dart';
import 'package:sqflite/sqlite_api.dart';

import '../models/note.dart';

abstract class INoteTableRepository<T extends NoteTable> extends Repository<NoteTable> {
  static const String tableName = "NoteTable";
  static String createNoteTableNoteTableString =
      'CREATE TABLE $tableName (id INTEGER PRIMARY KEY, noteId INTEGER FOREIGN KEY, rowCount INTEGER, columnCount INTEGER, title TEXT, createDateMillisSinceEpoch INTEGER, updateDateMillisSinceEpoch INTEGER)';

  Future<List<NoteTable>> getNoteTablesFromNoteId(int noteId);
}

class NoteTableRepository<T extends NoteTable> implements INoteTableRepository<NoteTable> {
  Database db;
  NoteTableRepository(this.db);
  String get tableName => INoteTableRepository.tableName;

  @override
  Future<List<NoteTable>> getNoteTablesFromNoteId(int noteId) async {
    List<Map> list = await db.rawQuery('SELECT * FROM $tableName WHERE noteId = ?', [noteId]);
    print(list.toString());
    return list.map((e) => NoteTable.fromMap(Map<String, dynamic>.from(e))).toList();
  }

  @override
  Future<NoteTable> create(NoteTable t) async {
    await db.insert(tableName, t.toMap());
    await db.transaction((txn) async {
      String id = t.id.toString();
      String noteId = t.noteId.toString();
      String rowCount = t.rowCount.toString();
      String columnCount = t.columnCount.toString();
      String title = t.title;
      String createDateMillisSinceEpoch = t.createDate.millisecondsSinceEpoch.toString();
      String updateDateMillisSinceEpoch = t.updateDate.millisecondsSinceEpoch.toString();
      int id1 = await txn.rawInsert(
          'INSERT or IGNORE INTO $tableName(id, noteId, rowCount, columnCount, title, createDateMillisSinceEpoch, updateDateMillisSinceEpoch) VALUES($id, $noteId, $rowCount, $columnCount, $title, $createDateMillisSinceEpoch, $updateDateMillisSinceEpoch)');
      Logger.root.info('inserted1: $id1');
    });
    return t;
  }

  @override
  Future<bool> delete(NoteTable t) async {
    try {
      await db.rawDelete('DELETE FROM $tableName WHERE id = ?', [t.id.toString()]);
    } catch (e) {
      LoggingService.logger.fine(e.toString());
      return false;
    }

    return true;
  }

  @override
  Future<NoteTable> getById(int id) async {
    List<Map> list = await db.rawQuery('SELECT * FROM $tableName WHERE id = ?', [id]);
    print(list.toString());
    return list.map((e) => NoteTable.fromMap(Map<String, dynamic>.from(e))).toList().first;
  }

  @override
  Future<bool> update(NoteTable t) async {
    int count = await db.rawUpdate(
        'UPDATE $tableName SET rowCount = ?, columnCount = ?, title = ?, createDateMillisSinceEpoch = ?, updateDateMillisSinceEpoch = ? WHERE id = ?',
        [t.rowCount, t.columnCount, t.title, t.createDate.millisecondsSinceEpoch, t.updateDate.millisecondsSinceEpoch]);
    print('updated: $count');
    return true;
  }
}
  // 'CREATE TABLE $tableName (id INTEGER PRIMARY KEY, noteId INTEGER FOREIGN KEY, rowCount INTEGER, columnCount INTEGER, title TEXT, createDateMillisSinceEpoch INTEGER, updateDateMillisSinceEpoch INTEGER)';

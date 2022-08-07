import 'package:logging/logging.dart';
import 'package:notime/data/repositories/_repository.dart';
import 'package:notime/services/logging_service.dart';
import 'package:sqflite/sqlite_api.dart';

import '../models/note.dart';

abstract class INoteRepository<T extends Note> extends Repository<Note> {
  static const String tableName = "Note";
  static String createNoteTableString =
      'CREATE TABLE $tableName (id INTEGER PRIMARY KEY, content TEXT, createDateMillisSinceEpoch INTEGER, updateDateMillisSinceEpoch INTEGER)';

  Future<List<Note>> getNotes();
}

class NoteRepository<T extends Note> implements INoteRepository<Note> {
  Database db;
  NoteRepository(this.db);
  String get tableName => INoteRepository.tableName;

  @override
  Future<List<Note>> getNotes() async {
    List<Map> list = await db.rawQuery('SELECT * FROM $tableName');
    print(list.toString());
    return list.map((e) => Note.fromMap(Map<String, dynamic>.from(e))).toList();
  }

  @override
  Future<Note> create(Note t) async {
    await db.insert(tableName, t.toMap());
    await db.transaction((txn) async {
      String id = t.id.toString();
      String content = t.content.toString();
      String createDateMillisSinceEpoch = t.createDate.millisecondsSinceEpoch.toString();
      String updateDateMillisSinceEpoch = t.updateDate.millisecondsSinceEpoch.toString();
      int id1 = await txn.rawInsert(
          'INSERT or IGNORE INTO $tableName(id, content, createDateMillisSinceEpoch, updateDateMillisSinceEpoch) VALUES($id, "$content", $createDateMillisSinceEpoch, $updateDateMillisSinceEpoch)');
      Logger.root.info('inserted1: $id1');
    });
    return t;
  }

  @override
  Future<bool> delete(Note t) async {
    try {
      await db.rawDelete('DELETE FROM $tableName WHERE id = ?', [t.id.toString()]);
    } catch (e) {
      LoggingService.logger.fine(e.toString());
      return false;
    }

    return true;
  }

  @override
  Future<Note> getById(int id) async {
    List<Map> list = await db.rawQuery('SELECT * FROM $tableName WHERE id = ?', [id]);
    print(list.toString());
    return list.map((e) => Note.fromMap(Map<String, dynamic>.from(e))).toList().first;
  }

  @override
  Future<bool> update(Note t) async {
    int count = await db.rawUpdate(
        'UPDATE $tableName SET content = ?, updateDateMillisSinceEpoch = ? WHERE id = ?',
        [t.content, t.updateDate.millisecondsSinceEpoch, t.id]);
    print('updated: $count');
    return true;
  }
}

import 'package:start_note/data/models/note_audio.dart';
import 'package:start_note/data/repositories/_repository.dart';
import 'package:start_note/services/logging_service.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class INoteAudioRepository<T extends NoteAudio>
    extends Repository<NoteAudio> {
  Future<List<NoteAudio>> getNoteAudiosFromNoteId(int noteId);
}

class NoteAudioRepository<T extends NoteAudio>
    implements INoteAudioRepository<NoteAudio> {
  Database db;
  NoteAudioRepository(this.db);
  String get tableName => NoteAudio.tableName;

  @override
  Future<NoteAudio> create(NoteAudio t) async {
    int noteId = await db.insert(tableName, t.toMap());
    return t.copyWith(id: noteId);
  }

  @override
  Future<bool> delete(NoteAudio t) async {
    try {
      await db
          .rawDelete('DELETE FROM $tableName WHERE id = ?', [t.id.toString()]);
    } catch (e) {
      LoggingService.logger.fine(e.toString());
      return false;
    }

    return true;
  }

  @override
  Future<NoteAudio> getById(int id) async {
    List<Map> list =
        await db.rawQuery('SELECT * FROM $tableName WHERE id = ?', [id]);
    print(list.toString());
    return list
        .map((e) => NoteAudio.fromMap(Map<String, dynamic>.from(e)))
        .toList()
        .first;
  }

  @override
  Future<bool> update(NoteAudio t) async {
    int count = await db.rawUpdate(
        'UPDATE $tableName SET content = ?, updateDateMillisecondsSinceEpoch = ?, filePath = ?, ordinal = ?, title = ? WHERE id = ?',
        [
          t.content,
          t.updateDate.millisecondsSinceEpoch,
          t.filePath,
          t.ordinal,
          t.title,
          t.id
        ]);
    print('updated: $count');
    return true;
  }

  @override
  Future<List<NoteAudio>> getAll() async {
    List<Map<String, dynamic>> list =
        await db.rawQuery('SELECT * FROM $tableName');
    return NoteAudio.fromQuery(list);
  }

  @override
  Future<List<NoteAudio>> getNoteAudiosFromNoteId(int noteId) async {
    List<Map<String, dynamic>> list = await db
        .rawQuery('SELECT * FROM $tableName WHERE noteId = ?', [noteId]);
    return NoteAudio.fromQuery(list);
  }
}

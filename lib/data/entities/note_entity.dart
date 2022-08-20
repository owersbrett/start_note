import 'package:start_note/data/entities/note_table_entity.dart';
import '../models/note.dart';

class NoteEntity extends Note {
  late List<NoteTableEntity> noteTables;
  NoteEntity({required super.id, required super.content, required super.createDate, required super.updateDate}) {
    this.noteTables = [];
  }

  static NoteEntity create() {
    return NoteEntity.fromNote(Note.create());
  }

  static NoteEntity fromNote(Note note) {
    NoteEntity noteEntity = NoteEntity(
      id: note.id,
      content: note.content,
      createDate: note.createDate,
      updateDate: note.updateDate,
    );
    return noteEntity;
  }

  NoteEntity copyEntityWith({
    Note? note,
    List<NoteTableEntity>? noteTables,
  }) {
    NoteEntity entity = NoteEntity.fromNote(
      note?.copyWith() ?? this,
    );
    entity.noteTables = noteTables ?? this.noteTables;
    return entity;
  }
}

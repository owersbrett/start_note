import 'package:start_note/data/models/note_table.dart';

import '../models/note.dart';

class NoteEntity extends Note {
  late List<NoteTable> noteTables;
  NoteEntity({required super.id, required super.content, required super.createDate, required super.updateDate}) {
    this.noteTables = [];
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
    List<NoteTable>? noteTables,
  }) {
    NoteEntity entity = NoteEntity.fromNote(
      note?.copyWith() ?? this,
    );
    entity.noteTables = noteTables ?? this.noteTables;
    return entity;
  }
}

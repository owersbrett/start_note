import 'package:start_note/data/entities/note_table_entity.dart';
import 'package:start_note/data/models/note_audio.dart';
import '../models/note.dart';

class NoteEntity extends Note {
  List<NoteTableEntity> noteTables;
  List<NoteAudio> noteAudios;
  NoteEntity({
    required super.id,
    required super.content,
    required super.createDate,
    required super.updateDate,
    this.noteTables = const [],
    this.noteAudios = const [],
  });

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
    List<NoteAudio>? noteAudios,
  }) {
    NoteEntity entity = NoteEntity.fromNote(
      note?.copyWith() ?? this,
    );
    entity.noteTables = noteTables ?? this.noteTables;
    entity.noteAudios = noteAudios ?? this.noteAudios;
    return entity;
  }
}

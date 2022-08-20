import 'package:equatable/equatable.dart';
import 'package:start_note/data/entities/note_entity.dart';
import 'package:start_note/data/entities/note_table_entity.dart';

abstract class NotePageState extends Equatable {
  const NotePageState();
  NoteEntity get initialNote;
  NoteEntity get note;
  @override
  List<Object> get props => [...note.noteTables.map((e) => e), ...note.noteTables.map((e) => e.cells.map((e) => e))];
}

class NotePageInitial extends NotePageState {
  NotePageInitial(this._noteEntity);
  final NoteEntity _noteEntity;
  @override
  NoteEntity get initialNote => _noteEntity;

  @override
  NoteEntity get note => _noteEntity;
}

class NotePageEmpty extends NotePageState {
  NotePageEmpty(this._noteEntity);
  final NoteEntity _noteEntity;
  @override
  NoteEntity get initialNote => _noteEntity;

  @override
  NoteEntity get note => _noteEntity;
}

class NotePageLoading extends NotePageState {
  NotePageLoading(this._noteEntity, this._note);
  final NoteEntity _noteEntity;
  final NoteEntity _note;
  @override
  NoteEntity get initialNote => _noteEntity;

  @override
  NoteEntity get note => _note;
}
class AddingColumn extends NotePageState {
  AddingColumn(this._noteEntity, this._note);
  final NoteEntity _noteEntity;
  final NoteEntity _note;
  @override
  NoteEntity get initialNote => _noteEntity;

  @override
  NoteEntity get note => _note;
}
class AddingRow extends NotePageState {
  AddingRow(this._noteEntity, this._note);
  final NoteEntity _noteEntity;
  final NoteEntity _note;
  @override
  NoteEntity get initialNote => _noteEntity;

  @override
  NoteEntity get note => _note;
}
class DeletingColumn extends NotePageState {
  DeletingColumn(this._noteEntity, this._note);
  final NoteEntity _noteEntity;
  final NoteEntity _note;
  @override
  NoteEntity get initialNote => _noteEntity;

  @override
  NoteEntity get note => _note;
}
class DeletingRow extends NotePageState {
  DeletingRow(this._noteEntity, this._note);
  final NoteEntity _noteEntity;
  final NoteEntity _note;
  @override
  NoteEntity get initialNote => _noteEntity;

  @override
  NoteEntity get note => _note;
}

class NotePageError extends NotePageState {
  NotePageError(this._noteEntity, this._note);
  final NoteEntity _noteEntity;
  final NoteEntity _note;
  @override
  NoteEntity get initialNote => _noteEntity;

  @override
  NoteEntity get note => _note;
}

class NotePageLoaded extends NotePageState {
  NotePageLoaded(this._noteEntity, this._note);
  final NoteEntity _noteEntity;
  final NoteEntity _note;
  NotePageLoaded copyWith({
    NoteEntity? noteEntity,
    List<NoteTableEntity>? noteTables,
  }) {
    return NotePageLoaded(
      _noteEntity.copyEntityWith(),
      noteEntity ?? this._note.copyEntityWith(noteTables: noteTables),
    );
  }

  @override
  NoteEntity get initialNote => _noteEntity;

  @override
  NoteEntity get note => _note;
}

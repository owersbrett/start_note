import 'package:equatable/equatable.dart';
import 'package:start_note/data/entities/note_entity.dart';

import '../../data/models/note_table.dart';

abstract class NotePageState extends Equatable {
  const NotePageState();
  NoteEntity get initialNote;
  NoteEntity get note;
  @override
  List<Object> get props => [];
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
    List<NoteTable>? noteTables,
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

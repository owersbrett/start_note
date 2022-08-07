import 'package:equatable/equatable.dart';

import '../../data/models/note.dart';

abstract class NotesState extends Equatable {
  List<Note> get notes;

  NotesState copyWith(List<Note> updatedNotes);
  @override
  List<Object> get props => [...notes.map((e) => e)];

  Map<String, dynamic>? toMap() {
    return {"notes": notes.map((e) => e.toMap()).toList()};
  }

  int get newNoteId {
    List<Note> currentNotes = List<Note>.from(notes)..sort((a, b) => b.createDate.compareTo(a.createDate));
    return currentNotes.isNotEmpty ? currentNotes[0].id + 1 : 0;
  }
}

class NotesInitial extends NotesState {
  @override
  List<Note> get notes => [];

  @override
  NotesState copyWith(List<Note> updatedNotes) => NotesInitial();
}

class NotesEmpty extends NotesState {
  @override
  List<Note> get notes => [];

  @override
  NotesState copyWith(List<Note> updatedNotes) => NotesEmpty();
}

class NotesLoading extends NotesState {
  NotesLoading(this._notes);
  final List<Note> _notes;
  @override
  List<Note> get notes => _notes;

  @override
  NotesState copyWith(List<Note> updatedNotes) => NotesLoading(updatedNotes);
}

class NotesError extends NotesState {
  NotesError(this._notes);
  final List<Note> _notes;
  @override
  List<Note> get notes => _notes;

  @override
  NotesState copyWith(List<Note> updatedNotes) => NotesError(updatedNotes);
}

class NotesLoaded extends NotesState {
  NotesLoaded(this._notes);
  final List<Note> _notes;
  @override
  NotesLoaded copyWith(List<Note> updatedNotes) => NotesLoaded(updatedNotes);

  @override
  List<Note> get notes => _notes;
}

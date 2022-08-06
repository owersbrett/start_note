import '../data/models/note.dart';

abstract class NotesEvent {
  const NotesEvent();
}

class FetchNotes extends NotesEvent {}

class AddNote extends NotesEvent {
  AddNote(this.content);
  final String  content;
}

class DeleteNote extends NotesEvent {
  DeleteNote(this.noteId);
  final int noteId;
}

class UpdateNote extends NotesEvent {
  UpdateNote(this.note);
  final Note note;
}

abstract class NotesEvent {
  const NotesEvent();
}

class FetchNotes extends NotesEvent {}

class AddNote extends NotesEvent {}

class DeleteNote extends NotesEvent {
  DeleteNote(this.noteId);
  final int noteId;
}

class AddNoteAudio extends NotesEvent {
  
}

class UpdateNote extends NotesEvent {
  UpdateNote(this.text, this.noteId);
  final String text;
  final int noteId;
}

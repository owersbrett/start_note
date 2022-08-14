abstract class NotePageEvent {
  const NotePageEvent();
}

class FetchNotePage extends NotePageEvent {}

class AddTable extends NotePageEvent {}

class SaveNoteDataCell extends NotePageEvent {
  SaveNoteDataCell(this.row, this.column, this.noteTableId, this.text);
  final int row;
  final int column;
  final int noteTableId;
  final String text;
}

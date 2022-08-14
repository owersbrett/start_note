abstract class NotePageEvent {
  const NotePageEvent();
}

class FetchNotePage extends NotePageEvent {}

class AddTable extends NotePageEvent {}

class SaveNoteTableTitle extends NotePageEvent {
  SaveNoteTableTitle(this.noteTableId, this.titleText);
  final int noteTableId;
  final String titleText;
}

class SaveNoteDataCell extends NotePageEvent {
  SaveNoteDataCell(this.row, this.column, this.noteTableId, this.text);
  final int row;
  final int column;
  final int noteTableId;
  final String text;
}

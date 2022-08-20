import 'package:start_note/data/entities/note_entity.dart';

abstract class CompareTableEvent {
  const CompareTableEvent();
}

class FetchCompareTable extends CompareTableEvent {
  final NoteEntity noteEntity;
  FetchCompareTable(this.noteEntity);
}


class EditTableHeader extends CompareTableEvent {
  final NoteEntity noteEntity;
  EditTableHeader(this.noteEntity);
}

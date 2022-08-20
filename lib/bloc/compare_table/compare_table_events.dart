import 'package:start_note/data/entities/note_entity.dart';

abstract class CompareTableEvent {
  const CompareTableEvent();
}

class FetchCompareTable extends CompareTableEvent {}


class EditTableHeader extends CompareTableEvent {
  final NoteEntity noteEntity;
  EditTableHeader(this.noteEntity);
}

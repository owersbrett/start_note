import 'package:equatable/equatable.dart';
import 'package:start_note/data/entities/note_table_entity.dart';

class CompareTableState extends Equatable {
  final Map<String, NoteTableEntity> similarTables;

  const CompareTableState(this.similarTables);

  NoteTableEntity previousNote(NoteTableEntity noteTableEntity) {
    if (similarTables.containsKey(noteTableEntity.title)) {
      return similarTables[noteTableEntity.title]!;
    } else {
      return noteTableEntity;
    }
  }

  @override
  List<Object> get props => [...similarTables.values.map((e) => e)];
}

class CompareTableInitial extends CompareTableState {
  CompareTableInitial(super.selectedTable);
}

class CompareTableEmpty extends CompareTableState {
  CompareTableEmpty(super.selectedTable);
}

class CompareTableLoading extends CompareTableState {
  CompareTableLoading(super.selectedTable);
}

class CompareTableError extends CompareTableState {
  CompareTableError(super.selectedTable);
}

class CompareTableLoaded extends CompareTableState {
  CompareTableLoaded(super.selectedTable);
}

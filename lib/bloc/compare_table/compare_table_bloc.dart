import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start_note/data/entities/note_entity.dart';
import 'package:start_note/data/repositories/note_table_repository.dart';
import '../../data/entities/note_table_entity.dart';
import 'compare_table.dart';

class CompareTableBloc extends Bloc<CompareTableEvent, CompareTableState> {
  final INoteTableRepository noteTableRepository;
  CompareTableBloc(this.noteTableRepository) : super(CompareTableInitial({})) {
    on(_onEvent);
  }
  void _onEvent(CompareTableEvent event, Emitter<CompareTableState> emit) async {
    if (event is SelectTable) await _selectTable(event, emit);
    if (event is EditTableHeader) await _editTableHeader(event, emit);
  }

  Future<void> _editTableHeader(EditTableHeader event, Emitter<CompareTableState> emit) async {
    try {
      NoteEntity noteEntity = event.noteEntity;
      Map<String, NoteTableEntity> similarTables = Map<String, NoteTableEntity>();
      for (var noteTable in noteEntity.noteTables) {
        List<NoteTableEntity> similarTablesList = await noteTableRepository.getTablesLike(noteTable);
        if (similarTablesList.length > 1) {
          var table = similarTablesList[1];
          similarTables[table.title] = table;
        } 
      }
      emit(CompareTableLoaded(similarTables));
    } catch (e) {
      print('error selecting table');
      print(e);
    }
  }

  Future<void> _selectTable(SelectTable event, Emitter<CompareTableState> emit) async {

  }
}

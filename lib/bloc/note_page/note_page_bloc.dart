import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start_note/data/entities/note_entity.dart';
import 'package:start_note/data/entities/note_table_entity.dart';
import 'package:start_note/data/models/note_table.dart';
import 'package:start_note/data/repositories/note_repository.dart';
import 'package:start_note/data/repositories/note_table_repository.dart';
import '../../data/models/note.dart';
import '../../data/models/note_table_cell.dart';
import 'note_page.dart';

class NotePageBloc extends Bloc<NotePageEvent, NotePageState> {
  NotePageBloc(this.initialNote, this.noteRepository, this.noteTableRepository) : super(NotePageInitial(initialNote)) {
    on(_onEvent);
  }
  final INoteRepository noteRepository;
  final INoteTableRepository noteTableRepository;
  final NoteEntity initialNote;
  void _onEvent(NotePageEvent event, Emitter<NotePageState> emit) async {
    if (event is FetchNotePage) await _fetchNotePage(event, emit);
    if (event is AddTable) await _addTable(event, emit);
    if (event is SaveNoteDataCell) await _saveNoteDataCell(event, emit);
    if (event is SaveNoteTableTitle) await _saveNoteTableTitle(event, emit);
    if (event is AddTableColumn) await _addTableColumn(event, emit);
    if (event is RemoveTableColumn) await _removeTableColumn(event, emit);
    if (event is AddTableRow) await _addTableRow(event, emit);
    if (event is RemoveTableRow) await _removeTableRow(event, emit);
  }

  Future<void> _addTableColumn(AddTableColumn event, Emitter<NotePageState> emit) async {
    try {
      if (state is NotePageLoaded) {
        NotePageLoaded loadedState = state as NotePageLoaded;
        emit(NotePageLoading(state.note, state.note));
        List<NoteTableEntity> noteTables = List<NoteTableEntity>.from(loadedState.note.noteTables);
        NoteTableEntity entity = noteTables.where((element) => element.id == event.noteTableId).first;
        int index = noteTables.indexOf(entity);
        entity = NoteTableEntity.fromNoteTableAndCells(entity.copyWith(updateDate: DateTime.now()), entity.cells);

        entity = await noteTableRepository.addColumn(entity);

        noteTables[index] = entity;

        NoteEntity note = loadedState.note.copyEntityWith(noteTables: noteTables);
        emit(NotePageLoaded(state.initialNote, note));
      }
    } catch (e) {
      emit(NotePageError(initialNote, initialNote));
    }
  }

  Future<void> _removeTableColumn(RemoveTableColumn event, Emitter<NotePageState> emit) async {
    print('removing column');
  }

  Future<void> _addTableRow(AddTableRow event, Emitter<NotePageState> emit) async {
    print('adding row');
  }

  Future<void> _removeTableRow(RemoveTableRow event, Emitter<NotePageState> emit) async {
    print('removing row');
  }

  Future<void> _saveNoteTableTitle(SaveNoteTableTitle event, Emitter<NotePageState> emit) async {
    try {
      if (state is NotePageLoaded) {
        NotePageLoaded loadedState = state as NotePageLoaded;
        List<NoteTableEntity> noteTables = List<NoteTableEntity>.from(loadedState.note.noteTables);
        NoteTableEntity entity = noteTables.where((element) => element.id == event.noteTableId).first;
        int index = noteTables.indexOf(entity);
        entity = NoteTableEntity.fromNoteTableAndCells(
          entity.copyWith(title: event.titleText, updateDate: DateTime.now()),
          entity.cells,
        );

        await noteTableRepository.update(entity);

        noteTables[index] = entity;

        loadedState.note.copyEntityWith(noteTables: noteTables);
      }
      NoteEntity note = NoteEntity.create();
      if (initialNote.id != null || state.note.id != null) {
        int id = initialNote.id ?? state.note.id!;
        note = await noteRepository.getEntityById(id, noteTableRepository);
      } else {
        note = await noteRepository.getNewNote();
      }
      emit(NotePageLoaded(initialNote, note));
    } catch (e) {
      emit(NotePageError(initialNote, state.note));
    }
  }

  Future<void> _saveNoteDataCell(SaveNoteDataCell event, Emitter<NotePageState> emit) async {
    try {
      if (state is NotePageLoaded) {
        NotePageLoaded loadedState = state as NotePageLoaded;
        List<NoteTableEntity> noteTables = List<NoteTableEntity>.from(loadedState.note.noteTables);
        NoteTableEntity entity = noteTables.where((element) => element.id == event.noteTableId).first;
        int index = noteTables.indexOf(entity);
        List<NoteTableCell> cells = List<NoteTableCell>.from(entity.cells);
        NoteTableCell cellToUpdate =
            cells.where((element) => element.row == event.row && element.column == event.column).first;
        int cellIndex = cells.indexOf(cellToUpdate);
        cellToUpdate = cellToUpdate.copyWith(content: event.text);
        cells[cellIndex] = cellToUpdate;
        await noteTableRepository.updateNoteTableCell(cellToUpdate);

        noteTables[index] = entity.copyWithCells(cells);

        loadedState.note.copyEntityWith(noteTables: noteTables);
      }
      NoteEntity note = NoteEntity.create();
      if (initialNote.id != null || state.note.id != null) {
        int id = initialNote.id ?? state.note.id!;
        note = await noteRepository.getEntityById(id, noteTableRepository);
      } else {
        note = await noteRepository.getNewNote();
      }
      emit(NotePageLoaded(initialNote, note));
    } catch (e) {
      emit(NotePageError(initialNote, state.note));
    }
  }

  Future<void> _fetchNotePage(FetchNotePage event, Emitter<NotePageState> emit) async {
    try {
      NoteEntity note = NoteEntity.create();
      if (initialNote.id != null) {
        note = await noteRepository.getEntityById(initialNote.id!, noteTableRepository);
      } else {
        note = await noteRepository.getNewNote();
      }
      emit(NotePageLoaded(initialNote, note));
    } catch (e) {
      emit(NotePageError(initialNote, state.note));
    }
  }

  Future<void> _addTable(AddTable event, Emitter<NotePageState> emit) async {
    try {
      if (state is NotePageLoaded) {
        NotePageLoaded currentState = state as NotePageLoaded;
        NoteTableEntity noteTable =
            NoteTableEntity.fromNoteTableAndCells(NoteTable.createFromNoteEntity(currentState.note), []);
        noteTable = await noteTableRepository.createNoteTableEntity(noteTable);
        List<NoteTableEntity> noteTables = List<NoteTableEntity>.from(currentState.note.noteTables);
        noteTables.add(noteTable);
        emit(currentState.copyWith(noteTables: noteTables));
      }
    } catch (e) {
      emit(NotePageError(initialNote, state.note));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start_note/data/entities/note_entity.dart';
import 'package:start_note/data/entities/note_table_entity.dart';
import 'package:start_note/data/models/note_table.dart';
import 'package:start_note/data/repositories/note_audio_repository.dart';
import 'package:start_note/data/repositories/note_repository.dart';
import 'package:start_note/data/repositories/note_table_repository.dart';
import '../../data/models/note_table_cell.dart';
import 'note_page.dart';

class NotePageBloc extends Bloc<NotePageEvent, NotePageState> {
  NotePageBloc(this.initialNote, this.noteRepository, this.noteTableRepository, this.noteAudioRepository)
      : super(NotePageInitial(initialNote)) {
    on(_onEvent);
  }
  final INoteRepository noteRepository;
  final INoteTableRepository noteTableRepository;
  final INoteAudioRepository noteAudioRepository;
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
    if (event is DoneTapped) await _doneTapped(event, emit);
    if (event is CutNoteAudio) await _cutNoteAudio(event, emit);
  }

  Future<void> _cutNoteAudio(
      CutNoteAudio event, Emitter<NotePageState> emit) async {
    try {
      if (state is NotePageLoaded) {
        print(event);
      }
    } catch (e) {
      emit(NotePageError(initialNote, initialNote));
    }
  }

  Future<void> _doneTapped(
      DoneTapped event, Emitter<NotePageState> emit) async {
    try {
      if (state is NotePageLoaded) {
        NotePageLoaded loadedState = state as NotePageLoaded;
        bool shouldFetch = await _shouldFetchNotePage(loadedState);
        if (shouldFetch) add(FetchNotePage(noteId: loadedState.note.id));
      }
    } catch (e) {
      emit(NotePageError(initialNote, initialNote));
    }
  }

  Future<void> _addTableColumn(
      AddTableColumn event, Emitter<NotePageState> emit) async {
    try {
      if (state is NotePageLoaded) {
        NotePageLoaded loadedState = state as NotePageLoaded;
        emit(AddingColumn(state.note, state.note));
        List<NoteTableEntity> noteTables =
            List<NoteTableEntity>.from(loadedState.note.noteTables);
        NoteTableEntity entity = noteTables
            .where((element) => element.id == event.noteTableId)
            .first;
        int index = noteTables.indexOf(entity);
        entity = NoteTableEntity.fromNoteTableAndCells(
            entity.copyWith(updateDate: DateTime.now()), entity.cells);

        entity = await noteTableRepository.addColumn(entity);

        noteTables[index] = entity;

        NoteEntity note =
            loadedState.note.copyEntityWith(noteTables: noteTables);
        emit(NotePageLoaded(state.initialNote, note));
      }
    } catch (e) {
      emit(NotePageError(initialNote, initialNote));
    }
  }

  Future<void> _removeTableColumn(
      RemoveTableColumn event, Emitter<NotePageState> emit) async {
    try {
      if (state is NotePageLoaded) {
        NotePageLoaded loadedState = state as NotePageLoaded;
        emit(DeletingColumn(state.note, state.note));
        List<NoteTableEntity> noteTables =
            List<NoteTableEntity>.from(loadedState.note.noteTables);
        NoteTableEntity? entity = noteTables
            .where((element) => element.id == event.noteTableId)
            .first;
        int index = noteTables.indexOf(entity);
        entity = NoteTableEntity.fromNoteTableAndCells(
            entity.copyWith(updateDate: DateTime.now()), entity.cells);

        entity = await noteTableRepository.removeColumn(entity);
        if (entity != null) {
          noteTables[index] = entity;
        } else {
          noteTables.removeAt(index);
        }

        NoteEntity note =
            loadedState.note.copyEntityWith(noteTables: noteTables);
        emit(NotePageLoaded(state.initialNote, note));
      }
    } catch (e) {
      emit(NotePageError(initialNote, initialNote));
    }
  }

  Future<void> _addTableRow(
      AddTableRow event, Emitter<NotePageState> emit) async {
    try {
      if (state is NotePageLoaded) {
        NotePageLoaded loadedState = state as NotePageLoaded;
        emit(AddingRow(state.note, state.note));
        List<NoteTableEntity> noteTables =
            List<NoteTableEntity>.from(loadedState.note.noteTables);
        NoteTableEntity entity = noteTables
            .where((element) => element.id == event.noteTableId)
            .first;
        int index = noteTables.indexOf(entity);
        entity = NoteTableEntity.fromNoteTableAndCells(
            entity.copyWith(updateDate: DateTime.now()), entity.cells);

        entity = await noteTableRepository.addRow(entity);

        noteTables[index] = entity;

        NoteEntity note =
            loadedState.note.copyEntityWith(noteTables: noteTables);
        emit(NotePageLoaded(state.initialNote, note));
      }
    } catch (e) {
      emit(NotePageError(initialNote, initialNote));
    }
  }

  Future<void> _removeTableRow(
      RemoveTableRow event, Emitter<NotePageState> emit) async {
    try {
      if (state is NotePageLoaded) {
        NotePageLoaded loadedState = state as NotePageLoaded;
        emit(DeletingRow(state.note, state.note));
        List<NoteTableEntity> noteTables =
            List<NoteTableEntity>.from(loadedState.note.noteTables);
        NoteTableEntity? entity = noteTables
            .where((element) => element.id == event.noteTableId)
            .first;
        int index = noteTables.indexOf(entity);
        entity = NoteTableEntity.fromNoteTableAndCells(
            entity.copyWith(updateDate: DateTime.now()), entity.cells);

        entity = await noteTableRepository.removeRow(entity);
        if (entity != null) {
          noteTables[index] = entity;
        } else {
          noteTables.removeAt(index);
        }

        NoteEntity note =
            loadedState.note.copyEntityWith(noteTables: noteTables);
        emit(NotePageLoaded(state.initialNote, note));
      }
    } catch (e) {
      emit(NotePageError(initialNote, initialNote));
    }
  }

  Future<void> _saveNoteTableTitle(
      SaveNoteTableTitle event, Emitter<NotePageState> emit) async {
    try {
      if (state is NotePageLoaded) {
        NotePageLoaded loadedState = state as NotePageLoaded;
        List<NoteTableEntity> noteTables =
            List<NoteTableEntity>.from(loadedState.note.noteTables);
        NoteTableEntity entity = noteTables
            .where((element) => element.id == event.noteTableId)
            .first;
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

  Future<void> _saveNoteDataCell(
      SaveNoteDataCell event, Emitter<NotePageState> emit) async {
    try {
      if (state is NotePageLoaded) {
        NotePageLoaded loadedState = state as NotePageLoaded;
        List<NoteTableEntity> noteTables =
            List<NoteTableEntity>.from(loadedState.note.noteTables);
        NoteTableEntity entity = noteTables
            .where((element) => element.id == event.noteTableId)
            .first;
        int index = noteTables.indexOf(entity);
        List<NoteTableCell> cells = List<NoteTableCell>.from(entity.cells);
        NoteTableCell cellToUpdate = cells
            .where((element) =>
                element.row == event.row && element.column == event.column)
            .first;
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

  Future<void> _fetchNotePage(
      FetchNotePage event, Emitter<NotePageState> emit) async {
    try {
      NoteEntity note = NoteEntity.create();
      if (initialNote.id != null || event.noteId != null) {
        note = await noteRepository.getEntityById(
            initialNote.id ?? event.noteId!, noteTableRepository);
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
        NoteTableEntity noteTable = NoteTableEntity.fromNoteTableAndCells(
            NoteTable.createFromNoteEntity(currentState.note), []);
        noteTable = await noteTableRepository.createNoteTableEntity(noteTable);
        List<NoteTableEntity> noteTables =
            List<NoteTableEntity>.from(currentState.note.noteTables);
        noteTables.add(noteTable);
        emit(currentState.copyWith(noteTables: noteTables));
      }
    } catch (e) {
      emit(NotePageError(initialNote, state.note));
    }
  }

  Future<bool> _shouldFetchNotePage(NotePageLoaded notePageLoaded) async {
    bool shouldFetch = false;
    for (var element in notePageLoaded.note.noteTables) {
      bool allAreEmpty = true;
      bool tableHasMultipleRows = element.rowCount > 1;
      if (tableHasMultipleRows) {
        element.rowColumnTableMap[element.rowCount]!.forEach((key, value) {
          if (!value.isEmpty) {
            allAreEmpty = false;
          }
        });
        if (allAreEmpty) {
          shouldFetch = true;
          await noteTableRepository.deleteLastRow(element);
        }
      }
    }
    return shouldFetch;
  }
}

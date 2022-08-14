import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start_note/data/entities/note_entity.dart';
import 'package:start_note/data/entities/note_table_entity.dart';
import 'package:start_note/data/models/note_table.dart';
import 'package:start_note/data/repositories/note_repository.dart';
import 'package:start_note/data/repositories/note_table_repository.dart';
import '../../data/models/note.dart';
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
      emit(NotePageError(initialNote, initialNote));
    }
  }

  Future<void> _addTable(AddTable event, Emitter<NotePageState> emit) async {
    try {
      if (state is NotePageLoaded) {
        NotePageLoaded currentState = state as NotePageLoaded;
        NoteTableEntity noteTable = NoteTableEntity.fromNoteTableAndCells(NoteTable.createFromNoteEntity(currentState.note), []);
        noteTable = await noteTableRepository.createNoteTableEntity(noteTable);
        List<NoteTableEntity> noteTables = List<NoteTableEntity>.from(currentState.note.noteTables);
        noteTables.add(noteTable);
        emit(currentState.copyWith(noteTables: noteTables));
      }
    } catch (e) {
      emit(NotePageError(initialNote, initialNote));
    }
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notime/data/repositories/note_repository.dart';
import '../data/models/note.dart';
import 'notes.dart';

class NotesBloc extends HydratedBloc<NotesEvent, NotesState> {
  NotesBloc(this.noteRepository) : super(NotesInitial()) {
    on(_onEvent);
  }
  final INoteRepository<Note> noteRepository;
  void _onEvent(NotesEvent event, Emitter<NotesState> emit) async {
    if (event is FetchNotes) await _fetchNotes(event, emit);
    if (event is AddNote) await _addNote(event, emit);
  }

  Future<void> _fetchNotes(FetchNotes event, Emitter<NotesState> emit) async {
    try {
      List<Note> notes = await noteRepository.getNotes();

      emit(NotesLoaded(notes..sort((a, b) => b.createDate.compareTo(a.createDate),)));
    } catch (e) {
      print(e);
      emit(NotesError(const []));
    }
  }

  Future<void> _addNote(AddNote event, Emitter<NotesState> emit) async {
    try {
      List<Note> currentNotes = state.notes..sort((a, b) => b.createDate.compareTo(a.createDate));
      int nextNoteId = currentNotes.isNotEmpty ? currentNotes[0].id + 1 : 0;
      noteRepository
          .create(Note(content: event.content, id: nextNoteId, createDate: DateTime.now(), updateDate: DateTime.now()));
    } catch (e) {
      emit(state);
    }
  }

  @override
  NotesState? fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> notesMap = json["notes"];
    List<Note> notes = notesMap.map((e) => Note.fromMap(e)).toList();

    return NotesLoaded(notes..sort((a, b) => b.updateDate.compareTo(a.updateDate)));
  }

  @override
  Map<String, dynamic>? toJson(NotesState state) {
    return state.toMap();
  }
}

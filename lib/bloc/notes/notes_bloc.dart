import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:start_note/data/repositories/note_repository.dart';
import '../../data/models/note.dart';
import 'notes.dart';

class NotesBloc extends HydratedBloc<NotesEvent, NotesState> {
  NotesBloc(this.noteRepository) : super(NotesInitial()) {
    on(_onEvent);
  }
  final INoteRepository<Note> noteRepository;
  void _onEvent(NotesEvent event, Emitter<NotesState> emit) async {
    if (event is FetchNotes) await _fetchNotes(event, emit);
    if (event is AddNote) await _addNote(event, emit);
    if (event is DeleteNote) await _deleteNote(event, emit);
    if (event is UpdateNote) await _updateNote(event, emit);
  }

  Future<void> _updateNote(UpdateNote event, Emitter<NotesState> emit) async {
    try {
      Note note = state.notes.firstWhere((element) => element.id == event.note.id);
      List<Note> notes = List<Note>.from(state.notes)..remove(note);
      notes.add(event.note);
      await noteRepository.update(event.note);
      emit(NotesLoaded(notes..sort((a, b) => b.createDate.compareTo(a.createDate))));
    } catch (e) {
      emit(NotesError(const []));
    }
  }

  Future<void> _deleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    try {
      Note note = state.notes.firstWhere((element) => element.id == event.noteId);
      List<Note> notes = List<Note>.from(state.notes)..remove(note);
      await noteRepository.delete(note);
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(const []));
    }
  }

  Future<void> _fetchNotes(FetchNotes event, Emitter<NotesState> emit) async {
    try {
      List<Note> notes = await noteRepository.getNotes();

      emit(NotesLoaded(notes..sort((a, b) => b.createDate.compareTo(a.createDate))));
      _deleteEmptyNotes(notes);
    } catch (e) {
      emit(NotesError(const []));
    }
  }

  void _deleteEmptyNotes(List<Note> notes) {
    Note? noteToDelete;
    for (var element in notes) {
      if (element.content.isEmpty) {
        noteToDelete = element;
      }
    }
    if (noteToDelete != null) {
      add(DeleteNote(noteToDelete.id));
    }
  }

  Future<void> _addNote(AddNote event, Emitter<NotesState> emit) async {
    try {
      noteRepository.create(event.note);
      emit(state.copyWith(List<Note>.from(state.notes)..add(event.note)));
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

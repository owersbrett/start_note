import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'notes.dart';

class NotesBloc extends HydratedBloc<NotesEvent, NotesState> {
  NotesBloc() : super(NotesInitial()) {
    on(_onEvent);
  }
  void _onEvent(NotesEvent event, Emitter<NotesState> emit) {}
  
  @override
  NotesState? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }
  
  @override
  Map<String, dynamic>? toJson(NotesState state) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'note_page.dart';
class NotePageBloc extends Bloc<NotePageEvent, NotePageState> {
NotePageBloc() : super(NotePageInitial()){
on(_onEvent);
}
void _onEvent(NotePageEvent event, Emitter<NotePageState> emit){
}
}
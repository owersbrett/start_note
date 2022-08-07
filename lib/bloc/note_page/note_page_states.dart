import 'package:equatable/equatable.dart';
class NotePageState extends Equatable {
const NotePageState();
@override
List<Object> get props => [];
}
class NotePageInitial extends NotePageState {}
class NotePageEmpty extends NotePageState {}
class NotePageLoading extends NotePageState {}
class NotePageError extends NotePageState {}
class NotePageLoaded extends NotePageState {}
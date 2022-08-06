import 'package:equatable/equatable.dart';
class NotesState extends Equatable {
const NotesState();
@override
List<Object> get props => [];
}
class NotesInitial extends NotesState {}
class NotesEmpty extends NotesState {}
class NotesLoading extends NotesState {}
class NotesError extends NotesState {}
class NotesLoaded extends NotesState {}
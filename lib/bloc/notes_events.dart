abstract class NotesEvent {
const NotesEvent();
}
class FetchNotes extends NotesEvent {}
class AddNote extends NotesEvent{}
class DeleteNote extends NotesEvent{}
class UpdateNote extends NotesEvent{}
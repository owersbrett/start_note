import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notime/pages/note_page.dart';
import 'package:notime/services/date_service.dart';
import '../bloc/notes/notes.dart';
import '../data/models/note.dart';
import '../navigation/navigation.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget _buildNotes(BuildContext context, Note note) {
    return Slidable(
      key: ValueKey(note.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (ctx) {
              BlocProvider.of<NotesBloc>(context).add(DeleteNote(note.id));
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          note.content,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Text(
          DateService.dateTimeToString(note.createDate),
          maxLines: 1,
        ),
        onTap: () {
          // createRoute
          Navigation.createRoute(NotePage(note: note), context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notime"),
      ),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.notes.length,
                    itemBuilder: (ctx, i) => _buildNotes(ctx, state.notes[i]),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 10,
                  color: Theme.of(context).bottomAppBarColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Notes: ${state.notes.length}"),
                        IconButton(
                          icon: Icon(Icons.create),
                          onPressed: () {
                            Note note = Note(
                                id: state.newNoteId,
                                content: "",
                                createDate: DateTime.now(),
                                updateDate: DateTime.now());
                            BlocProvider.of<NotesBloc>(context).add(AddNote(note));
                            Navigation.createRoute(
                                NotePage(
                                  note: note,
                                ),
                                context);
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

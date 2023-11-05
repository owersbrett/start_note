import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start_note/data/entities/note_entity.dart';
import 'package:start_note/pages/note_page.dart';
import 'package:start_note/services/date_service.dart';
import 'package:start_note/theme/application_theme.dart';
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
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return Dialog(
                      child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Delete note?",
                                  style: Theme.of(context).textTheme.headlineSmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      BlocProvider.of<NotesBloc>(context).add(DeleteNote(note.id!));
                                    },
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: ApplicationTheme.red, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(color: ApplicationTheme.grey, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                    );
                  });
            },
            backgroundColor:ApplicationTheme.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            autoClose: true,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              note.content.isEmpty ? DateService.dateTimeToWeekDay(note.createDate) : note.content,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              DateService.dateTimeToString(note.createDate),
              maxLines: 1,
              style: TextStyle(color: Colors.black.withOpacity(.8), fontWeight: FontWeight.w400),
            ),
            onTap: () {
              // createRoute
              Navigation.createRoute(NotePage(note: NoteEntity.fromNote(note)), context);
              
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 16),
            child: Divider(
              height: 1,
              color: Colors.black87,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start Note"),
        
      ),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesLoaded || state is AddingNote) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.amber.withOpacity(.9)),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.notes.length,
                      itemBuilder: (ctx, i) => _buildNotes(ctx, state.notes[i]),
                    ),
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
                            BlocProvider.of<NotesBloc>(context).add(AddNote());
                            Navigation.createRoute(NotePage(note: NoteEntity.fromNote(Note.create())), context);
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }

          return InkWell(
            child: Container(
              color: Colors.amberAccent,
              child: Center(
                child: Text(
                  "UH oh! Error loading notes. Tab anywhere to fix this.",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            onTap: () {
              BlocProvider.of<NotesBloc>(context).add(FetchNotes());
            },
          );
        },
      ),
    );
  }
}

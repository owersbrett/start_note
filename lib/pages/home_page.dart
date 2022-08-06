import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notime/pages/note_page.dart';
import 'package:notime/services/date_service.dart';
import '../bloc/notes.dart';
import '../data/models/note.dart';
import '../navigation/navigation.dart';
import '../util/display.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget _buildNotes(BuildContext context, Note note) {
    return Slidable(
      child: ListTile(
        title: Text(Display.substring(note.content, 0, 42), maxLines: 2,),
        subtitle: Text(DateService.dateTimeToString(note.createDate), maxLines: 1,),
    
        onTap: () {
          // createRoute
          Navigation.createRoute( NotePage(note: note), context);
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
                  child: Row(
                    children: [
                      Icon(Icons.abc),
                      Text("Note count"),
                      IconButton(
                        icon: Icon(Icons.create),
                        onPressed: () {
                          Navigation.createRoute(const NotePage(), context);
                        },
                      ),
                    ],
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

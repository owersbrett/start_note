import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start_note/data/entities/note_entity.dart';

import 'package:start_note/pages/note_page/table_display.dart';

import '../../bloc/note_page/note_page_bloc.dart';
import '../../bloc/note_page/note_page_events.dart';

class TableTab extends StatelessWidget {
  const TableTab({Key? key, required this.note, required this.notePageBloc}) : super(key: key);
  final NoteEntity note;
  final NotePageBloc notePageBloc;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: ListView.builder(
              itemCount: note.noteTables.length,
              itemBuilder: ((context, index) =>
                  TableDisplay(noteTable: note.noteTables[index], notePageBloc: notePageBloc)),
            ),
          ),
          MaterialButton(
            color: Theme.of(context).backgroundColor,
            child: Text(
              "Insert Table",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: () {
              notePageBloc.add(AddTable());
            },
          ),
        ],
      ),
    );
  }
}

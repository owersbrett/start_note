import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start_note/common/note_table_display.dart';
import 'package:start_note/common/stopwatch_app_bar.dart';
import 'package:start_note/data/entities/note_entity.dart';
import 'package:start_note/data/entities/note_table_entity.dart';
import 'package:start_note/data/repositories/note_table_repository.dart';

import 'package:start_note/pages/note_page/table_display.dart';
import 'package:start_note/services/date_service.dart';

import '../bloc/note_page/note_page.dart';
import '../bloc/notes/notes.dart';
import '../data/models/note_table.dart';
import '../data/repositories/note_repository.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key, required this.note}) : super(key: key);
  final NoteEntity note;

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late TextEditingController noteController;
  late NotePageBloc notePageBloc;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    notePageBloc = NotePageBloc(
      widget.note,
      RepositoryProvider.of<INoteRepository>(context),
      RepositoryProvider.of<INoteTableRepository>(context),
    )..add(FetchNotePage());
    noteController = TextEditingController(text: widget.note.content);
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    notePageBloc.close();
    super.dispose();
  }

  void onDone(int? id) {
    focusNode.unfocus();
    BlocProvider.of<NotesBloc>(context).add(UpdateNote(noteController.text, id!));
  }

  Widget _tableBuilder(NoteTableEntity noteTable) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Title'),
        Container(
          height: 100,
          child: Editable(
            columnRatio: 1 / (noteTable.columnCount + 1),
            columnCount: noteTable.columnCount,
            rowCount: noteTable.rowCount,
          ),
        ),
      ],
    );
    return ListTile(
      title: Text(noteTable.title),
    );
    // return NoteTableDisplay(noteTable: noteTable);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<NotesBloc>(context).add(FetchNotes());
        return true;
      },
      child: DefaultTabController(
        length: 2,
        child: BlocBuilder<NotePageBloc, NotePageState>(
          bloc: notePageBloc,
          builder: (context, state) {
            return Scaffold(
              appBar: StopwatchAppBar(
                  onDone: () => onDone(state.note.id), key: ValueKey(state.note.id), focusNode: focusNode),
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: "Notes"),
                      Tab(text: "Tables"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                          child: Column(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: noteController,
                                  focusNode: focusNode,
                                  decoration: null,
                                  maxLines: 99999,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: state.note.noteTables.length,
                                  itemBuilder: ((context, index) => _tableBuilder(state.note.noteTables[index])),
                                ),
                              ),
                              MaterialButton(
                                child: Text("Insert Table"),
                                onPressed: () {
                                  notePageBloc.add(AddTable());
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, left: 8),
                        child: Center(
                          child: Text(
                            DateService.dateTimeToWeekDay(widget.note.createDate) +
                                ", " +
                                DateService.dateTimeToString(widget.note.createDate),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start_note/common/stopwatch_app_bar.dart';
import 'package:start_note/data/entities/note_entity.dart';
import 'package:start_note/data/repositories/note_table_repository.dart';

import 'package:start_note/pages/note_page/table_display.dart';
import 'package:start_note/services/date_service.dart';

import '../bloc/note_page/note_page.dart';
import '../bloc/notes/notes.dart';
import '../data/repositories/note_repository.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key, required this.note}) : super(key: key);
  final NoteEntity note;

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> with SingleTickerProviderStateMixin {
  late TextEditingController noteController;
  late NotePageBloc notePageBloc;
  late FocusNode focusNode;
  late TabController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Create TabController for getting the index of current tab
    notePageBloc = NotePageBloc(
      widget.note,
      RepositoryProvider.of<INoteRepository>(context),
      RepositoryProvider.of<INoteTableRepository>(context),
    )..add(FetchNotePage());
    noteController = TextEditingController(text: widget.note.content);
    focusNode = FocusNode();
    _controller = TabController(length: 2, vsync: this);

    _controller.addListener(_tabListener);
  }

  void _tabListener() {
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    notePageBloc.close();
    _controller.removeListener(_tabListener);
    _controller.dispose();
    super.dispose();
  }

  void onChanged(int? id) {
    BlocProvider.of<NotesBloc>(context).add(UpdateNote(noteController.text, id!));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<NotesBloc>(context).add(FetchNotes());
        return true;
      },
      child: BlocBuilder<NotePageBloc, NotePageState>(
        bloc: notePageBloc,
        builder: (context, state) {
          return Scaffold(
            appBar: StopwatchAppBar(key: ValueKey(state.note.id)),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  controller: _controller,
                  tabs: [
                    Tab(text: "Notes"),
                    Tab(text: "Tables"),
                  ],
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: TabBarView(
                    controller: _controller,
                    children: [
                      Column(
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                              child: TextField(
                                controller: noteController,
                                focusNode: focusNode,
                                decoration: null,
                                onChanged: (value) {
                                  onChanged(state.note.id);
                                },
                                maxLines: 99999,
                              ),
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
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: ListView.builder(
                                itemCount: state.note.noteTables.length,
                                itemBuilder: ((context, index) =>
                                    TableDisplay(noteTable: state.note.noteTables[index], notePageBloc: notePageBloc)),
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
              ],
            ),
          );
        },
      ),
    );
  }
}

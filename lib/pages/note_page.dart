import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start_note/common/stopwatch_app_bar.dart';
import 'package:start_note/data/entities/note_entity.dart';
import 'package:start_note/data/repositories/note_table_repository.dart';

import 'package:start_note/pages/note_page/table_display.dart';
import 'package:start_note/services/date_service.dart';

import '../bloc/app/app_bloc.dart';
import '../bloc/app/app_events.dart';
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
    super.initState();
    notePageBloc = NotePageBloc(
      widget.note,
      RepositoryProvider.of<INoteRepository>(context),
      RepositoryProvider.of<INoteTableRepository>(context),
    )..add(FetchNotePage());
    noteController = TextEditingController(text: widget.note.content);
    focusNode = FocusNode();
    _controller = TabController(
        length: 2, vsync: this, initialIndex: BlocProvider.of<AppBloc>(context).state.mostRecentNotePageTabIndex);

    _controller.addListener(_tabListener);
  }

  void _tabListener() {
    FocusScope.of(context).unfocus();
    BlocProvider.of<AppBloc>(context).add(TabBarTapped(_controller.index));
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

  Widget _notes(int? noteId) {
    return Column(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 16, right: 16),
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: noteController,
              focusNode: focusNode,
              decoration: null,
              style: TextStyle(color: Colors.black),
              onChanged: (value) {
                onChanged(noteId);
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
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        BlocProvider.of<NotesBloc>(context).add(FetchNotes());
        return true;
      },
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx < 100) {
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<NotePageBloc, NotePageState>(
          bloc: notePageBloc,
          builder: (context, state) {
            return Scaffold(
              appBar: StopwatchAppBar(
                key: ValueKey(state.note.id),
                notePageBloc: notePageBloc,
              ),
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TabBar(
                    onTap: (value) {
                      BlocProvider.of<AppBloc>(context).add(TabBarTapped(value));
                    },
                    labelColor: Colors.black,
                    indicatorColor: Colors.black,
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
                        _notes(state.note.id),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: ListView.builder(
                                  itemCount: state.note.noteTables.length,
                                  itemBuilder: ((context, index) => TableDisplay(
                                      noteTable: state.note.noteTables[index], notePageBloc: notePageBloc)),
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
                        ),
                      ],
                    ),
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

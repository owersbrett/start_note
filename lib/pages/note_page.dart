import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start_note/data/entities/note_entity.dart';
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
  late FocusNode noteFocusNode;
  late Stopwatch stopwatch;
  late Timer timer;
  late NotePageBloc notePageBloc;
  late int millisecondCount;
  @override
  void initState() {
    super.initState();
    notePageBloc = NotePageBloc(
      widget.note,
      RepositoryProvider.of<INoteRepository>(context),
      RepositoryProvider.of<INoteTableRepository>(context),
    )..add(FetchNotePage());
    millisecondCount = 0;
    noteController = TextEditingController(text: widget.note.content);
    noteFocusNode = FocusNode();
    noteFocusNode.requestFocus();
    stopwatch = Stopwatch();
    timer = Timer.periodic(const Duration(milliseconds: 10), _updateDisplay);
  }

  @override
  void dispose() {
    timer.cancel();
    stopwatch.stop();
    notePageBloc.close();
    super.dispose();
  }

  void _updateDisplay(Timer timer) {
    setState(() {
      millisecondCount = stopwatch.elapsedMilliseconds;
    });
  }

  void _toggleStopwatch() => stopwatch.isRunning ? stopwatch.stop() : stopwatch.start();

  void _resetStopwatch() => stopwatch.reset();

  String _getTimeString(int time) {
    String str = time.toString();
    if (str.length < 2) {
      return "0$str";
    }
    return str;
  }

  int get _centiseconds {
    int milliseconds = millisecondCount;
    while (milliseconds >= 1000) {
      milliseconds -= 1000;
    }
    return (milliseconds / 10).floor();
  }

  int get _seconds {
    double seconds = millisecondCount / 1000;
    while (seconds >= 60) {
      seconds -= 60;
    }
    return (seconds).floor();
  }

  int get _minutes {
    double minutes = millisecondCount / 60000;
    while (minutes >= 60) {
      minutes -= 60;
    }
    return (minutes).floor();
  }

  int get _hours => (_minutes / 60).floor();

  String get _centisecondsString => _getTimeString(_centiseconds);
  String get _secondsString => _getTimeString(_seconds);
  String get _minutesString => _getTimeString(_minutes);
  String get _hoursString => _getTimeString(_hours);

  String get _stopwatchStringWithoutHour => "$_minutesString:$_secondsString:$_centisecondsString";
  String get _stopwatchStringWithHour => "$_hoursString:$_minutesString:$_secondsString:$_centisecondsString";
  String get _stopwatchString => _hours >= 1 ? _stopwatchStringWithHour : _stopwatchStringWithoutHour;

  void onDone() {
    noteFocusNode.unfocus();

    BlocProvider.of<NotesBloc>(context).add(
      UpdateNote(widget.note.copyWith(updateDate: DateTime.now(), content: noteController.text)),
    );
  }

  Widget _tableBuilder(NoteTable noteTable) {
    return NoteTableDisplay(noteTable: noteTable);
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
        child: Scaffold(
          appBar: AppBar(
            title: TextButton(
              onPressed: () => _toggleStopwatch(),
              onLongPress: () => _resetStopwatch(),
              child: Text(
                _stopwatchString,
                style: const TextStyle(
                  fontSize: 22,
                  fontFeatures: [
                    FontFeature.tabularFigures(),
                  ],
                ),
              ),
            ),
            actions: [
              noteFocusNode.hasFocus
                  ? TextButton(
                      child: const Text("Done", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        onDone();
                      },
                    )
                  : Container(),
            ],
          ),
          body: BlocBuilder<NotePageBloc, NotePageState>(
            bloc: notePageBloc,
            builder: (context, state) {
              // if (state is NotePageLoaded) {
              if (state is NotePageLoaded) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TabBar(
                      tabs: [
                        Tab(
                          text: "Notes",
                        ),
                        Tab(
                          text: "Tables",
                        ),
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
                                    focusNode: noteFocusNode,
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
                                    itemBuilder: ((context, index) =>
                                        _tableBuilder(state.initialNote.noteTables[index])),
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
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}

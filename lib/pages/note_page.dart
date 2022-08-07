import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:notime/pages/note_page/table_display.dart';
import 'package:notime/services/date_service.dart';

import '../bloc/note_page/note_page.dart';
import '../bloc/notes/notes.dart';
import '../data/models/note.dart';
import '../data/models/note_table.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key, required this.note}) : super(key: key);
  final Note note;

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
    notePageBloc = NotePageBloc();
    millisecondCount = 0;
    noteController = TextEditingController(text: widget.note.content);
    noteFocusNode = FocusNode();
    widget.note == null ? noteFocusNode.requestFocus() : null;
    stopwatch = Stopwatch();
    timer = Timer.periodic(const Duration(milliseconds: 10), _updateDisplay);
  }

  @override
  void dispose() {
    timer.cancel();
    stopwatch.stop();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<NotesBloc>(context).add(FetchNotes());
        return true;
      },
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
            if (true) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                        child: Text(
                          DateService.dateTimeToWeekDay(widget.note.createDate),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          DateService.dateTimeToString(widget.note.createDate),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: noteController,
                        focusNode: noteFocusNode,
                        decoration: null,
                        maxLines: 99999,
                      ),
                    ),
                    // Expanded(
                    //   child: ListView(
                    //     scrollDirection: Axis.horizontal,
                    //     children: [
                    //       NoteTableDisplay(
                    //         noteTable: NoteTable(
                    //           id: 0,
                    //           updateDate: DateTime.now(),
                    //           createDate: DateTime.now(),
                    //           columnCount: 2,
                    //           rowCount: 2,
                    //           title: "",
                    //           noteId: widget.note.id,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              );
            }
            return Container(
              child: Text("Loading"),
            );
          },
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notime/bloc/notes.dart';
import 'package:notime/services/date_service.dart';

import '../data/models/note.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key, this.note}) : super(key: key);
  final Note? note;

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late TextEditingController noteController;
  late FocusNode noteFocusNode;
  late Stopwatch stopwatch;
  late Timer timer;
  late DateTime createDate;
  late int millisecondCount;
  @override
  void initState() {
    super.initState();
    millisecondCount = 0;
    noteController = TextEditingController(text: widget.note?.content ?? "");
    noteFocusNode = FocusNode();
    widget.note == null ? noteFocusNode.requestFocus() : null;
    stopwatch = Stopwatch();
    timer = Timer.periodic(const Duration(milliseconds: 10), _updateDisplay);
    createDate = DateTime.now();
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

  void onDone() {
    noteFocusNode.unfocus();
    if (widget.note != null) {
      BlocProvider.of<NotesBloc>(context).add(
        UpdateNote(widget.note!.copyWith(updateDate: DateTime.now(), content: noteController.text)),
      );
    } else {
      BlocProvider.of<NotesBloc>(context).add(
        AddNote(noteController.text),
      );
    }
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
              "$_minutesString:$_secondsString:$_centisecondsString",
              style: const TextStyle(
                fontSize: 22,
                fontFeatures: [
                  FontFeature.tabularFigures(),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                "Done",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                onDone();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
          child: Column(
            children: [
              Center(
                child: Text(DateService.dateTimeToString(createDate)),
              ),
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
      ),
    );
  }
}

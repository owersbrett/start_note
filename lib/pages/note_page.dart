import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

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
    noteController = TextEditingController();
    noteFocusNode = FocusNode()..requestFocus();
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

  void _toggleStopwatch() {
    stopwatch.isRunning ? stopwatch.stop() : stopwatch.start();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$_minutesString:$_secondsString:$_centisecondsString",
          style: const TextStyle(
            fontFeatures: [
              FontFeature.tabularFigures(),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              "Done",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              noteFocusNode.unfocus();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
        child: Column(
          children: [
            Center(
              child: Text(createDate.toString()),
            ),
            Expanded(
              child: TextField(
                controller: noteController,
                focusNode: noteFocusNode,
                decoration: null,
                maxLines: 99999,
              ),
            ),
            MaterialButton(
              child: Text("Start the clock"),
              onPressed: () => _toggleStopwatch(),
            )
          ],
        ),
      ),
    );
  }
}

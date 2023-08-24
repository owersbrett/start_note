import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:start_note/util/tooltips.dart';
import '../bloc/note_page/note_page.dart';

class StopwatchAppBar extends StatelessWidget implements PreferredSize {
  const StopwatchAppBar({Key? key, required this.notePageBloc}) : super(key: key);
  final NotePageBloc notePageBloc;

  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  Widget get child => StopwatchBar(notePageBloc: notePageBloc);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class StopwatchBar extends StatefulWidget {
  const StopwatchBar({Key? key, required this.notePageBloc}) : super(key: key);
  final NotePageBloc notePageBloc;

  @override
  State<StopwatchBar> createState() => _StopwatchBarState();
}

class _StopwatchBarState extends State<StopwatchBar> {
  late Stopwatch stopwatch;
  late Timer timer;
  late int millisecondCount;

  @override
  void initState() {
    super.initState();
    millisecondCount = 0;
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

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Tooltip(
        message: Tooltips.stopwatch,
        child: TextButton(
          onPressed: () => _toggleStopwatch(),
          onLongPress: () => _resetStopwatch(),
          child: Text(
            _stopwatchString,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontFeatures: [
                FontFeature.tabularFigures(),
              ],
            ),
          ),
        ),
      ),
      actions: [
        FocusScope.of(context).hasFocus
            ? Tooltip(
                message: Tooltips.done,
                child: TextButton(
                  child: const Text("Done", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    widget.notePageBloc.add(DoneTapped());
                    FocusScope.of(context).unfocus();
                  },
                ),
              )
            : Container(),
      ],
    );
  }
}

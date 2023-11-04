import 'package:flutter/material.dart';
import 'package:start_note/data/models/note_audio.dart';
import '../../data/models/note.dart';
import '../../services/date_service.dart';
import '../../widget/common/audio_text_widget.dart';

class AudioTab extends StatefulWidget {
  const AudioTab(
      {Key? key,
      required this.note,
      required this.focusNode,
      required this.noteController,
      required this.onChanged})
      : super(key: key);
  final Note note;
  final FocusNode focusNode;
  final TextEditingController noteController;
  final Function(int) onChanged;

  @override
  State<AudioTab> createState() => _AudioTabState();
}

class _AudioTabState extends State<AudioTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AudioTextWidget(
          noteAudio: NoteAudio(
              noteId: 1,
              filePath: "/",
              content: "Note Audio",
              index: 1,
              createDate: DateTime.now(),
              updateDate: DateTime.now()),
        ),
        AudioTextWidget(
          noteAudio: NoteAudio(
            noteId: 2,
            filePath: "/",
            content: "Note Audio 2",
            index: 2,
            createDate: DateTime.now(),
            updateDate: DateTime.now(),
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 8),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Created on: ",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    Text(
                      DateService.dateTimeToWeekDay(widget.note.createDate) +
                          ", " +
                          DateService.dateTimeToString(widget.note.createDate),
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

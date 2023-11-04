import 'package:flutter/material.dart';
import 'package:start_note/data/entities/note_entity.dart';
import 'package:start_note/data/models/note_audio.dart';
import '../../services/date_service.dart';
import '../../widget/common/audio_text_widget.dart';

class AudioTab extends StatefulWidget {
  const AudioTab(
      {Key? key,
      required this.noteEntity,
      required this.focusNode,
      required this.noteController,
      required this.onChanged})
      : super(key: key);
  final NoteEntity noteEntity;
  final FocusNode focusNode;
  final TextEditingController noteController;
  final Function(int) onChanged;

  @override
  State<AudioTab> createState() => _AudioTabState();
}

class _AudioTabState extends State<AudioTab> {
  List<NoteAudio> get noteAudios => widget.noteEntity.noteAudios;
  List<AudioTextWidget> get _audioTextWidgets =>
      noteAudios.map((e) => AudioTextWidget(noteAudio: e)).toList();
  List<AudioTextWidget> get audioTextWidgets =>
      _audioTextWidgets.isEmpty ? [AudioTextWidget()] : _audioTextWidgets;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...audioTextWidgets,
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
                      DateService.dateTimeToWeekDay(
                              widget.noteEntity.createDate) +
                          ", " +
                          DateService.dateTimeToString(
                              widget.noteEntity.createDate),
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

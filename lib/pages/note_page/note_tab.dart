import 'package:flutter/material.dart';

import '../../data/models/note.dart';
import '../../services/date_service.dart';

class NoteTab extends StatelessWidget {
  const NoteTab(
      {Key? key, required this.note, required this.focusNode, required this.noteController, required this.onChanged})
      : super(key: key);
  final Note note;
  final FocusNode focusNode;
  final TextEditingController noteController;
  final Function(int) onChanged;
  @override
  Widget build(BuildContext context) {
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
                onChanged(note.id!);
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Created on: ",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    Text(
                      DateService.dateTimeToWeekDay(note.createDate) +
                          ", " +
                          DateService.dateTimeToString(note.createDate),
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

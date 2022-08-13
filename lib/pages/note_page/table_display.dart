import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import 'package:start_note/data/models/note_table.dart';

class NoteTableDisplay extends StatefulWidget {
  const NoteTableDisplay({Key? key, required this.noteTable}) : super(key: key);
  final NoteTable noteTable;
  @override
  State<NoteTableDisplay> createState() => _NoteTableDisplayState();
}

class _NoteTableDisplayState extends State<NoteTableDisplay> {
  late TextEditingController tableTitleController;
  late FocusNode tableTitleFocusNode;

  late NoteTable noteTable;
  @override
  void initState() {
    super.initState();
    tableTitleController = TextEditingController(text: widget.noteTable.title);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: TextField(controller: tableTitleController)),
        Expanded(
          child: Editable(
            rowCount: widget.noteTable.rowCount,
            columnCount: widget.noteTable.columnCount,
            onRowSaved: (data) {
              print(data);
            },
          ),
        ),
      ],
    );
  }
}

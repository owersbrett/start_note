import 'package:flutter/material.dart';
import 'package:start_note/common/note_table_display.dart';
import 'package:start_note/data/entities/note_table_entity.dart';

import '../../bloc/note_page/note_page.dart';
import '../../data/models/note_table_cell.dart';

class TableDisplay extends StatefulWidget {
  const TableDisplay({Key? key, required this.noteTable, required this.notePageBloc}) : super(key: key);
  final NotePageBloc notePageBloc;
  final NoteTableEntity noteTable;

  @override
  State<TableDisplay> createState() => _TableDisplayState();
}

class _TableDisplayState extends State<TableDisplay> {
  late TextEditingController titleController;
  late Map<int, Map<int, FocusNode>> focusNodes;

  @override
  void initState() {
    super.initState();
    initializeFocusNodes();
    titleController = TextEditingController(text: widget.noteTable.title);
  }

  @override
  void dispose() {
    titleController.dispose();
    focusNodes.forEach((key, cell) {
      cell[key]?.dispose();
    });
    super.dispose();
  }

  void initializeFocusNodes() {
    focusNodes = {};
    List<NoteTableCell> cells = widget.noteTable.cells;
    cells.forEach((cell) {
      focusNodes[cell.row] == null ? focusNodes[cell.row] = {} : null;
      focusNodes[cell.row]![cell.column] = FocusNode();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24, bottom: 12, top: 12),
          child: TextField(
            controller: titleController,
            decoration: InputDecoration.collapsed(hintText: "Title"),
            textCapitalization: TextCapitalization.sentences,
            textAlign: TextAlign.center,
            onChanged: (value) {
              widget.notePageBloc.add(SaveNoteTableTitle(widget.noteTable.id!, value));
            },
            onEditingComplete: () {
              focusNodes[1]?[1]?.requestFocus();
            },
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: GestureDetector(
            onTap: () {
              print('felt that');
            },
            child: Editable(
              columnRatio: 1 / (widget.noteTable.columnCount),
              columnCount: widget.noteTable.columnCount,
              noteTableCells: widget.noteTable.cells,
              rowCount: widget.noteTable.rowCount,
              noteTable: widget.noteTable,
              focusNodeMap: focusNodes,
              onChanged: (value, row, column) {
                widget.notePageBloc.add(SaveNoteDataCell(row, column, widget.noteTable.id!, value));
              },
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import 'package:start_note/data/entities/note_table_entity.dart';
import 'package:start_note/data/models/note_table.dart';
import 'package:start_note/pages/note_page/cell_display.dart';

import '../../data/models/note_table_cell.dart';

class NoteTableDisplay extends StatefulWidget {
  const NoteTableDisplay({Key? key, required this.noteTable}) : super(key: key);
  final NoteTableEntity noteTable;
  @override
  State<NoteTableDisplay> createState() => _NoteTableDisplayState();
}

class _NoteTableDisplayState extends State<NoteTableDisplay> {
  late TextEditingController tableTitleController;
  late FocusNode tableTitleFocusNode;

  @override
  void initState() {
    super.initState();
    tableTitleController = TextEditingController(text: widget.noteTable.title);
  }

  List<Widget> _buildRows() {
    int rowCount = 1;
    List<Widget> rows = [];
    
    while (rowCount < widget.noteTable.rowCount) {
      rows.add(_buildRow(widget.noteTable.cells.where((element) => element.row == rowCount).toList()));
      rowCount++;
    }
    return rows;
  }

Widget _buildRow(List<NoteTableCell> cells) {
    List<Widget> children = [];
    cells.forEach((element) {
      children.add(_buildCell(element.content, element.row, element.column));
    });
    return Row(children: children, mainAxisSize: MainAxisSize.min);
  }

  CellDisplay _buildCell(String value, int rowIndex, int columnIndex) {
    return CellDisplay(
      row: rowIndex,
      column: columnIndex,
      totalColumns: widget.noteTable.columnCount,
      initialText: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: _buildRows(), mainAxisSize: MainAxisSize.min,);
  }
}

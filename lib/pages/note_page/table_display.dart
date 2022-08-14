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

  bool get cellsHaveFocus {
    bool haveFocus = false;
    focusNodes.forEach((key, value) {
      value.forEach((key, value) {
        if (value.hasFocus) {
          haveFocus = true;
        }
      });
    });
    return haveFocus;
  }

  void addColumnOfFocusNodes() {
    int newColumnCount = widget.noteTable.columnCount + 1;
    focusNodes.forEach((key, value) {
      focusNodes[key]![newColumnCount] = FocusNode();
    });
  }

  void addRowOfFocusNodes() {
    int newRowCount = widget.noteTable.rowCount + 1;
    focusNodes[newRowCount] = {};
    focusNodes[1]!.forEach((key, value) {
      focusNodes[newRowCount]![key] = FocusNode();
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
          child: Editable(
            columnRatio: 1 / (widget.noteTable.columnCount),
            columnCount: widget.noteTable.columnCount,
            // rows: widget.noteTable.rows,
            // columns: widget.noteTable.columns,
            onCellTap: (row, column) {
              setState(() {});
            },
            noteTableCells: widget.noteTable.cells,
            rowCount: widget.noteTable.rowCount,
            noteTable: widget.noteTable,
            focusNodeMap: focusNodes,
            onChanged: (value, row, column) {
              widget.notePageBloc.add(SaveNoteDataCell(row, column, widget.noteTable.id!, value));
            },
          ),
        ),
        cellsHaveFocus
            ? Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {
                          widget.notePageBloc.add(RemoveTableColumn(widget.noteTable.id!));
                        },
                        icon: Icon(Icons.view_column_outlined)),
                    IconButton(
                        onPressed: () {
                          addColumnOfFocusNodes();
                          widget.notePageBloc.add(AddTableColumn(widget.noteTable.id!));
                        },
                        icon: Icon(Icons.view_column_sharp)),
                    IconButton(
                        onPressed: () {
                          widget.notePageBloc.add(RemoveTableRow(widget.noteTable.id!));
                        },
                        icon: Icon(Icons.table_rows_outlined)),
                    IconButton(
                        onPressed: () {
                          widget.notePageBloc.add(AddTableRow(widget.noteTable.id!));
                        },
                        icon: Icon(Icons.table_rows_sharp)),
                  ],
                ),
              )
            : Container()
      ],
    );
  }
}

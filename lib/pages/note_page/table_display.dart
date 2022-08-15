import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late int newFocusRow;
  late int newFocusColumn;

  @override
  void initState() {
    super.initState();
    newFocusRow = widget.noteTable.rowCount;
    newFocusColumn = widget.noteTable.columnCount;
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
    return MultiBlocListener(
      listeners: [
        BlocListener<NotePageBloc, NotePageState>(
          bloc: widget.notePageBloc,
          listener: (context, state) {
            focusNodes[1]?[widget.noteTable.columnCount + 1]?.requestFocus();
          },
          listenWhen: (previous, current) {
            return (previous is AddingColumn && current is NotePageLoaded);
          },
        ),
        BlocListener<NotePageBloc, NotePageState>(
          bloc: widget.notePageBloc,
          listener: (context, state) {
            focusNodes[widget.noteTable.rowCount + 1]?[1]?.requestFocus();
          },
          listenWhen: (previous, current) {
            return (previous is AddingRow && current is NotePageLoaded);
          },
        ),
        BlocListener<NotePageBloc, NotePageState>(
          bloc: widget.notePageBloc,
          listener: (context, state) {
            focusNodes[newFocusRow]?[newFocusColumn]?.requestFocus();
          },
          listenWhen: (previous, current) {
            return (previous is DeletingColumn && current is NotePageLoaded);
          },
        ),
        BlocListener<NotePageBloc, NotePageState>(
          bloc: widget.notePageBloc,
          listener: (context, state) {
            focusNodes[newFocusRow]?[newFocusColumn]?.requestFocus();
          },
          listenWhen: (previous, current) {
            return (previous is DeletingRow && current is NotePageLoaded);
          },
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24, bottom: 12, top: 12),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration.collapsed(
                  hintText: "Title", hintStyle: TextStyle(color: Colors.grey.withOpacity(.5))),
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
              onCellEditingComplete: (row, column) {
                print('complete');
                if (
                  widget.noteTable.rowColumnTableMap[row]![column]!.isEmpty) {
                  FocusScope.of(context).unfocus();
                } else {
                  bool nextColumnExists = focusNodes[row]![column + 1] != null;
                  nextColumnExists ? focusNodes[row]![column + 1]!.requestFocus() : null;
                  if (!nextColumnExists) {
                    bool nextRowExists = focusNodes[row + 1] != null;
                    nextRowExists ? focusNodes[row + 1]![1]!.requestFocus() : null;
                    if (!nextRowExists && widget.noteTable.rowColumnTableMap[row]![column]!.isNotEmpty) {
                      addRowOfFocusNodes();
                      widget.notePageBloc.add(AddTableRow(widget.noteTable.id!));
                    } else if (nextRowExists) {
                      focusNodes[row + 1]![1]?.requestFocus();
                    } else {
                      FocusScope.of(context).unfocus();
                    }
                  }
                }
              },
              onCellTap: (row, column) {},
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
                          color: Colors.red,
                          onPressed: () {
                            setState(() {
                              newFocusColumn = widget.noteTable.columnCount - 1;
                              newFocusRow = widget.noteTable.rowCount;
                            });
                            widget.notePageBloc.add(RemoveTableColumn(widget.noteTable.id!));
                          },
                          icon: Icon(Icons.view_column_outlined)),
                      IconButton(
                          color: Colors.green,
                          onPressed: () {
                            addColumnOfFocusNodes();
                            widget.notePageBloc.add(AddTableColumn(widget.noteTable.id!));
                          },
                          icon: Icon(Icons.view_column_sharp)),
                      IconButton(
                          color: Colors.red,
                          onPressed: () {
                            setState(() {
                              newFocusColumn = widget.noteTable.columnCount;
                              newFocusRow = widget.noteTable.rowCount - 1;
                            });
                            widget.notePageBloc.add(RemoveTableRow(widget.noteTable.id!));
                          },
                          icon: Icon(Icons.table_rows_outlined)),
                      IconButton(
                          color: Colors.green,
                          onPressed: () {
                            addRowOfFocusNodes();
                            widget.notePageBloc.add(AddTableRow(widget.noteTable.id!));
                          },
                          icon: Icon(Icons.table_rows_sharp)),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

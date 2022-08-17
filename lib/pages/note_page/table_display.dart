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
    newFocusRow = 1;
    newFocusColumn = 1;
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

  bool get currentCellIsEmpty => widget.noteTable.rowColumnTableMap[newFocusRow]?[newFocusColumn]?.isEmpty ?? true;
  bool cellIsEmpty(int row, int column) => widget.noteTable.rowColumnTableMap[row]![column]!.isEmpty;
  bool onLastColumn(int column) => widget.noteTable.columnCount == column;
  bool onLastRow(int row) => widget.noteTable.rowCount == row;
  FocusNode nextEmptyFocusNodeInRow(int row, int column) {
    FocusNode focusNode = focusNodes[row]![column + 1]!;
    for (var rowEntry in widget.noteTable.rowColumnTableMap.entries) {
      var rowKey = rowEntry.key;
      var rowValue = rowEntry.value;
      for (var columnEntry in rowValue.entries) {
        var columnKey = columnEntry.key;
        var columnValue = columnEntry.value;
        if (columnKey >= column) {
          if (columnValue.isEmpty) {
            return focusNodes[rowKey]![columnKey]!;
          }
        }
      }
    }
    return focusNode;
  }

  FocusNode firstEmptyFocusNodeInNextColumnOrFirst(int row, int column) {
    FocusNode focusNode = focusNodes[row + 1]![1]!;
    for (var rowEntry in widget.noteTable.rowColumnTableMap.entries) {
      var rowKey = rowEntry.key;
      var rowValue = rowEntry.value;
      if (rowKey >= row) {
        for (var columnEntry in rowValue.entries) {
          var columnKey = columnEntry.key;
          var columnValue = columnEntry.value;
          if (columnValue.isEmpty) {
            return focusNodes[rowKey]![columnKey]!;
          }
        }
      }
    }

    return focusNode;
  }

  void onCellEditingComplete(int row, int column) {
    if (cellIsEmpty(row, column)) {
      widget.notePageBloc.add(DoneTapped());
      FocusScope.of(context).unfocus();
    } else if (!onLastColumn(column)) {
      nextEmptyFocusNodeInRow(row, column).requestFocus();
    } else if (!onLastRow(row)) {
      firstEmptyFocusNodeInNextColumnOrFirst(row, column).requestFocus();
    } else if (onLastColumn(column) && onLastRow(row)) {
      bool addRow = widget.noteTable.columnCount == column && widget.noteTable.rowCount == row;
      if (addRow) {
        addRowOfFocusNodes();
        widget.notePageBloc.add(AddTableRow(widget.noteTable.id!));
      }
    }
    // else {
    //   FocusNode? focusNodeOfCellToTheRightOfCurrentCell = focusNodes[row]![column + 1];
    //   bool nextColumnExists = focusNodeOfCellToTheRightOfCurrentCell != null;
    //   if (nextColumnExists) {
    //     focusNodeOfCellToTheRightOfCurrentCell.requestFocus();
    //     setState(() {
    //       newFocusColumn = row;
    //       newFocusRow = column + 1;
    //     });
    //   } else {
    //     List<FocusNode>? nextRowFocusNodes = focusNodes[row + 1]?.values.toList();
    //     List<String>? nextRowValues = widget.noteTable.rowColumnTableMap[row + 1]?.values.toList();
    //     bool nextRowExists = nextRowFocusNodes != null && nextRowValues != null;

    //     if (nextRowExists) {
    //       int columnNumber = 1;
    //       FocusNode? nodeToRequest;
    //       nextRowFocusNodes.forEach((element) {
    //         Map<int, String> currentRow = widget.noteTable.rowColumnTableMap[row + 1]!;
    //         if (currentRow[columnNumber]!.isNotEmpty && nodeToRequest == null) {
    //           setState(() {
    //             newFocusRow = row + 1;
    //             newFocusColumn = columnNumber;
    //           });
    //           nodeToRequest = focusNodes[row + 1]?[columnNumber];
    //         }
    //         columnNumber++;
    //       });
    //       nodeToRequest?.requestFocus();
    //     } else {
    //       addRowOfFocusNodes();
    //       setState(() {
    //         newFocusRow = row + 1;
    //         newFocusColumn = 1;
    //       });
    //       widget.notePageBloc.add(AddTableRow(widget.noteTable.id!));
    //     }
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NotePageBloc, NotePageState>(
          bloc: widget.notePageBloc,
          listener: (context, state) {
            nextEmptyFocusNodeInRow(newFocusRow, newFocusRow);
          },
          listenWhen: (previous, current) {
            return (previous is AddingColumn && current is NotePageLoaded);
          },
        ),
        BlocListener<NotePageBloc, NotePageState>(
          bloc: widget.notePageBloc,
          listener: (context, state) {
            if (!currentCellIsEmpty) focusNodes[widget.noteTable.rowCount + 1]?[1]?.requestFocus();
          },
          listenWhen: (previous, current) {
            return (previous is AddingRow && current is NotePageLoaded);
          },
        ),
        BlocListener<NotePageBloc, NotePageState>(
          bloc: widget.notePageBloc,
          listener: (context, state) {
            if (!currentCellIsEmpty) focusNodes[newFocusRow]?[newFocusColumn]?.requestFocus();
          },
          listenWhen: (previous, current) {
            return (previous is DeletingColumn && current is NotePageLoaded);
          },
        ),
        BlocListener<NotePageBloc, NotePageState>(
          bloc: widget.notePageBloc,
          listener: (context, state) {
            if (!currentCellIsEmpty) focusNodes[newFocusRow]?[newFocusColumn]?.requestFocus();
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
                  hintText: "Title", hintStyle: TextStyle(color: Colors.black.withOpacity(.3))),
              textCapitalization: TextCapitalization.sentences,
              textAlign: TextAlign.center,
              onChanged: (value) {
                widget.notePageBloc.add(SaveNoteTableTitle(widget.noteTable.id!, value));
              },
              onEditingComplete: () {
                focusNodes[1]?[1]?.requestFocus();
              },
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).backgroundColor, width: 2),
              ),
              child: Editable(
                tdStyle: TextStyle(color: Colors.black),
                borderWidth: 2,
                borderColor: Theme.of(context).backgroundColor,
                tdAlignment: TextAlign.center,
                columnRatio: 1 / (widget.noteTable.columnCount),
                columnCount: widget.noteTable.columnCount,
                onCellEditingComplete: onCellEditingComplete,
                onCellTap: (row, column) {
                  setState(() {
                    newFocusColumn = column;
                    newFocusRow = row;
                  });
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
          ),
          cellsHaveFocus
              ? Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                            onTap: () {
                              setState(() {
                                newFocusColumn = widget.noteTable.columnCount - 1;
                                newFocusRow = widget.noteTable.rowCount;
                              });

                              widget.notePageBloc.add(RemoveTableColumn(widget.noteTable.id!));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.view_column_outlined,
                                color: Colors.red,
                              ),
                            )),
                        InkWell(
                            onTap: () {
                              setState(() {
                                newFocusColumn = widget.noteTable.columnCount + 1;
                                newFocusRow = 1;
                              });
                              addColumnOfFocusNodes();
                              widget.notePageBloc.add(AddTableColumn(widget.noteTable.id!));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.view_column_sharp,
                                color: Colors.green,
                              ),
                            )),
                        InkWell(
                            onTap: () {
                              setState(() {
                                newFocusColumn = widget.noteTable.columnCount;
                                newFocusRow = widget.noteTable.rowCount - 1;
                              });
                              widget.notePageBloc.add(RemoveTableRow(widget.noteTable.id!));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.table_rows_outlined,
                                color: Colors.red,
                              ),
                            )),
                        InkWell(
                            onTap: () {
                              addRowOfFocusNodes();
                              widget.notePageBloc.add(AddTableRow(widget.noteTable.id!));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.table_rows_sharp,
                                color: Colors.green,
                              ),
                            )),
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

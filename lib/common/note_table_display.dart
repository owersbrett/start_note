// Copyright 2020 Godwin Asuquo. All rights reserved.
//
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:start_note/data/entities/note_table_entity.dart';
import 'package:start_note/data/models/note_table_cell.dart';
import 'body.dart';

class Editable extends StatefulWidget {
  Editable(
      {Key? key,
      this.columns,
      required this.focusNodeMap,
      this.rows,
      this.columnRatio = 0.20,
      required this.onChanged,
      required this.noteTableCells,
      required this.noteTable,
      required this.onCellTap,
      required this.onCellEditingComplete,
      this.onRowSaved,
      this.columnCount = 0,
      this.rowCount = 0,
      this.borderColor = Colors.grey,
      this.tdPaddingLeft = 8.0,
      this.tdPaddingTop = 8.0,
      this.tdPaddingRight = 8.0,
      this.tdPaddingBottom = 12.0,
      this.thPaddingLeft = 8.0,
      this.thPaddingTop = 0.0,
      this.thPaddingRight = 8.0,
      this.thPaddingBottom = 0.0,
      this.trHeight = 50.0,
      this.borderWidth = 0.5,
      this.thWeight = FontWeight.w600,
      this.thSize = 18,
      this.showSaveIcon = false,
      this.saveIcon = Icons.save,
      this.saveIconColor = Colors.black12,
      this.saveIconSize = 18,
      this.tdAlignment = TextAlign.start,
      this.tdStyle,
      this.tdEditableMaxLines = 1,
      this.thAlignment = TextAlign.start,
      this.thStyle,
      this.thVertAlignment = CrossAxisAlignment.center,
      this.showCreateButton = false,
      this.createButtonAlign = CrossAxisAlignment.start,
      this.createButtonIcon,
      this.createButtonColor,
      this.createButtonShape,
      this.createButtonLabel,
      this.stripeColor1 = Colors.white,
      this.stripeColor2 = Colors.black12,
      this.zebraStripe = false,
      this.focusedBorder})
      : super(key: key);

  final Function(int, int) onCellTap;
  final Function(int, int) onCellEditingComplete;
  final NoteTableEntity noteTable;

  /// A data set to create headers
  ///
  /// Can be null if blank columns are needed, else:
  /// Must be array of objects
  /// with the following keys: [title], [widthFactor] and [key]
  ///
  /// example:
  /// ```dart
  /// List cols = [
  ///   {"title":'Name', 'widthFactor': 0.1, 'key':'name', 'editable': false},
  ///   {"title":'Date', 'widthFactor': 0.2, 'key':'date'},
  ///   {"title":'Month', 'widthFactor': 0.1, 'key':'month', 'editable': false},
  ///   {"title":'Status', 'widthFactor': 0.1, 'key':'status'},
  /// ];
  /// ```
  /// [title] is the column heading
  ///
  /// [widthFactor] a custom size ratio of each column width, if not provided, defaults to  [columnRatio = 0.20]
  /// ```dart
  /// 'widthFactor': 0.1 //gives 10% of screen size to the column
  /// 'widthFactor': 0.2 //gives 20% of screen size to the column
  /// ```
  ///
  /// [key] an identifier preferably a short string
  /// [editable] a boolean, if the column should be editable or not, [true] by default.
  final List? columns;

  /// A data set to create rows
  ///
  /// Can be null if empty rows are needed. else,
  /// Must be array of objects
  /// with keys matching [key] provided in the column array
  ///
  /// example:
  /// ```dart
  ///List rows = [
  ///          {"name": 'James Joe', "date":'23/09/2020',"month":'June',"status":'completed'},
  ///          {"name": 'Daniel Paul', "date":'12/4/2020',"month":'March',"status":'new'},
  ///        ];
  /// ```
  /// each objects DO NOT have to be positioned in same order as its column

  final List? rows;

  /// Used to prepopulate cells
  final List<NoteTableCell> noteTableCells;

  final Map<int, Map<int, FocusNode>> focusNodeMap;

  /// Interger value of number of rows to be generated:
  ///
  /// Optional if row data is provided
  final int rowCount;

  /// Interger value of number of columns to be generated:
  ///
  /// Optional if column data is provided
  final int columnCount;

  /// aspect ration of each column,
  /// sets the ratio of the screen width occupied by each column
  /// it is set in fraction between 0 to 1.0
  /// 0.8 indicates 80 percent width per column
  final double columnRatio;

  /// Color of table border
  final Color borderColor;

  /// width of table borders
  final double borderWidth;

  /// Table data cell padding left
  final double tdPaddingLeft;

  /// Table data cell padding top
  final double tdPaddingTop;

  /// Table data cell padding right
  final double tdPaddingRight;

  /// Table data cell padding bottom
  final double tdPaddingBottom;

  /// Aligns the table data
  final TextAlign tdAlignment;

  /// Style the table data
  final TextStyle? tdStyle;

  /// Max lines allowed in editable text, default: 1 (longer data will not wrap and be hidden), setting to 100 will allow wrapping and not increase row size
  final int tdEditableMaxLines;

  /// Table header cell padding left
  final double thPaddingLeft;

  /// Table header cell padding top
  final double thPaddingTop;

  /// Table header cell padding right
  final double thPaddingRight;

  /// Table header cell padding bottom
  final double thPaddingBottom;

  /// Aligns the table header
  final TextAlign thAlignment;

  /// Style the table header - use for more control of header style, using this OVERRIDES the thWeight and thSize parameters and those will be ignored.
  final TextStyle? thStyle;

  /// Table headers fontweight (use thStyle for more control of header style)
  final FontWeight thWeight;

  /// Table header label vertical alignment
  final CrossAxisAlignment thVertAlignment;

  /// Table headers fontSize  (use thStyle for more control of header style)
  final double thSize;

  /// Table Row Height
  /// cannot be less than 40.0
  final double trHeight;

  /// Toogles the save button,
  /// if [true] displays an icon to save rows,
  /// adds an addition column to the right
  final bool showSaveIcon;

  /// Icon for to save row data
  /// example:
  ///
  /// ```dart
  /// saveIcon : Icons.add
  /// ````
  final IconData saveIcon;

  /// Color for the save Icon
  final Color saveIconColor;

  /// Size for the saveIcon
  final double saveIconSize;

  /// displays a button that adds a new row onPressed
  final bool showCreateButton;

  /// Aligns the button for adding new rows
  final CrossAxisAlignment createButtonAlign;

  /// Icon displayed in the create new row button
  final Icon? createButtonIcon;

  /// Color for the create new row button
  final Color? createButtonColor;

  /// border shape of the create new row button
  ///
  /// ```dart
  /// createButtonShape: RoundedRectangleBorder(
  ///   borderRadius: BorderRadius.circular(8)
  /// )
  /// ```
  final BoxShape? createButtonShape;

  /// Label for the create new row button
  final Widget? createButtonLabel;

  /// The first row alternate color, if stripe is set to true
  final Color stripeColor1;

  /// The Second row alternate color, if stripe is set to true
  final Color stripeColor2;

  /// enable zebra-striping, set to false by default
  /// if enabled, you can style the colors [stripeColor1] and [stripeColor2]
  final bool zebraStripe;

  final InputBorder? focusedBorder;

  ///[onChanged] callback is triggered when the enter button is pressed on a table data cell
  /// it returns a value of the cell data
  final Function(String, int, int) onChanged;

  /// [onRowSaved] callback is triggered when a [saveButton] is pressed.
  /// returns only values if row is edited, otherwise returns a string ['no edit']
  final ValueChanged<dynamic>? onRowSaved;

  @override
  EditableState createState() => EditableState();
}

class EditableState extends State<Editable> {
  /// Temporarily holds all edited rows

  String _getInitialValue(int rowIndex, int columnIndex) {
    NoteTableCell cell =
        widget.noteTableCells.where((element) => element.row == rowIndex && element.column == columnIndex).first;
    return cell.content;
  }

  List<Widget> _tableRows() {
    return List<Widget>.generate(widget.rowCount, (index) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(widget.columnCount, (rowIndex) {
          return RowBuilder(
            row: index + 1,
            column: rowIndex + 1,
            initialValue: _getInitialValue(index + 1, rowIndex + 1),
            index: index,
            trHeight: widget.trHeight,
            borderColor: widget.borderColor,
            borderWidth: widget.borderWidth,
            tdPaddingLeft: widget.tdPaddingLeft,
            tdPaddingTop: widget.tdPaddingTop,
            tdPaddingBottom: widget.tdPaddingBottom,
            tdPaddingRight: widget.tdPaddingRight,
            tdAlignment: widget.tdAlignment,
            tdStyle: widget.tdStyle,
            tdEditableMaxLines: widget.tdEditableMaxLines,
            widthRatio: widget.columnRatio,
            zebraStripe: widget.zebraStripe,
            focusedBorder: widget.focusedBorder,
            stripeColor1: widget.stripeColor1,
            stripeColor2: widget.stripeColor2,
            onChanged: widget.onChanged,
            focusNode: widget.focusNodeMap[index + 1]?[rowIndex + 1] ?? FocusNode(),
            onCellEditingComplete: widget.onCellEditingComplete,
            onCellTap: (int row, int column) {
              widget.onCellTap(row, column);
              print("tapped cell " + row.toString() + ", " + column.toString());
            },
          );
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    /// initial Setup of columns and row, sets count of column and row
    // columns = columns ?? columnBlueprint(columnCount, columns);
    // rows = rows ?? rowBlueprint(rowCount!, columns, rows);

    /// Generates table rows

    return Material(
      color: Colors.transparent,
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: widget.createButtonAlign, children: [
        Flexible(
          fit: FlexFit.loose,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _tableRows(),
          ),
        )
      ]),
    );
  }
}

import 'package:flutter/material.dart';

class RowBuilder extends StatefulWidget {
  ///Builds row elements for the table
  /// its properties are not nullable
  const RowBuilder({
    Key? key,
    required this.row,
    required this.column,
    required this.tdAlignment,
    required this.tdStyle,
    required double trHeight,
    required Color borderColor,
    required double borderWidth,
    required this.index,
    required this.tdPaddingLeft,
    required this.tdPaddingTop,
    required this.tdPaddingBottom,
    required this.tdPaddingRight,
    required this.tdEditableMaxLines,
    required this.onChanged,
    required this.initialValue,
    required this.widthRatio,
    required this.stripeColor1,
    required this.stripeColor2,
    required this.zebraStripe,
    required this.focusedBorder,
    required this.onCellTap,
    required this.onCellEditingComplete,
    required this.focusNode,
  })  : _trHeight = trHeight,
        _borderColor = borderColor,
        _borderWidth = borderWidth,
        super(key: key);

  /// Table row height
  final double _trHeight;
  final Color _borderColor;
  final int row;
  final int column;
  final double _borderWidth;
  final String initialValue;
  final double widthRatio;
  final FocusNode focusNode;
  final TextAlign tdAlignment;
  final TextStyle? tdStyle;
  final int index;
  final double tdPaddingLeft;
  final double tdPaddingTop;
  final double tdPaddingBottom;
  final double tdPaddingRight;
  final int tdEditableMaxLines;
  final Color stripeColor1;

  final Color stripeColor2;
  final bool zebraStripe;
  final InputBorder? focusedBorder;
  final Function(String, int, int) onChanged;
  final Function(int, int) onCellTap;
  final Function(int, int) onCellEditingComplete;

  @override
  _RowBuilderState createState() => _RowBuilderState();
}

class _RowBuilderState extends State<RowBuilder> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Flexible(
      fit: FlexFit.loose,
      flex: 6,
      child: Container(
        height: widget._trHeight < 40 ? 40 : widget._trHeight,
        width: width * widget.widthRatio,
        decoration: BoxDecoration(
            color: !widget.zebraStripe ? null : (widget.index % 2 == 1.0 ? widget.stripeColor2 : widget.stripeColor1),
            border: Border.all(color: widget._borderColor, width: widget._borderWidth)),
        child: TextFormField(
          textAlign: widget.tdAlignment,
          style: widget.tdStyle,
          initialValue: widget.initialValue,
          // onFieldSubmitted: (String value) {
          //   widget.onSubmitted(value, widget.row, widget.column);
          // },
          focusNode: widget.focusNode,
          onTap: () {
            widget.onCellTap(widget.row, widget.column);
          },
          onEditingComplete: () {
            widget.onCellEditingComplete(widget.row, widget.column);
          },
          onChanged: (String value) {
            widget.onChanged(value, widget.row, widget.column);
          },
          textAlignVertical: TextAlignVertical.center,
          textCapitalization: TextCapitalization.words,
          maxLines: widget.tdEditableMaxLines,
          decoration: InputDecoration(
            filled: widget.zebraStripe,
            fillColor: widget.index % 2 == 1.0 ? widget.stripeColor2 : widget.stripeColor1,
            contentPadding: EdgeInsets.only(
                left: widget.tdPaddingLeft,
                right: widget.tdPaddingRight,
                top: widget.tdPaddingTop,
                bottom: widget.tdPaddingBottom),
            border: InputBorder.none,
            focusedBorder: widget.focusedBorder,
          ),
        ),
      ),
    );
  }
}

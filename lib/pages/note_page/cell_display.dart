import 'package:flutter/material.dart';

class CellDisplay extends StatefulWidget {
  const CellDisplay(
      {Key? key, required this.row, required this.column, required this.totalColumns, required this.initialText})
      : super(key: key);
  final int row;
  final int column;
  final int totalColumns;
  final String initialText;

  @override
  State<CellDisplay> createState() => _CellDisplayState();
}

class _CellDisplayState extends State<CellDisplay> {
  late TextEditingController controller;
  final double height = kToolbarHeight;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  double getWidth() {
    return (MediaQuery.of(context).size.width - 32) / widget.totalColumns;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: TextField(
          controller: controller,
        ),
      ),
      decoration: BoxDecoration(
      color: Colors.white,
        border: Border.all(color: Colors.yellowAccent, width: 2),
      ),
    );
  }
}

import 'package:flutter/material.dart';
class TimerDisplay extends StatelessWidget {
  const TimerDisplay({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("", style: Theme.of(context).textTheme.displayLarge);
  }
}

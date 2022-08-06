import 'package:flutter/material.dart';
import 'package:notime/pages/note_page.dart';
import '../navigation/navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget _buildNotes(BuildContext context, int index) {
    return ListTile(
      title: const Text("Note Title"),
      subtitle: const Text("Note Subtitle"),
      onTap: () {
        // createRoute
        Navigation.createRoute(const NotePage(), context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notime"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: _buildNotes,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 9,
            child: Row(
              children: const [
                Icon(Icons.abc),
                Text("Note count"),
                Icon(Icons.create),
              ],
            ),
          )
        ],
      ),
    );
  }
}

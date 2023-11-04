import 'package:flutter/material.dart';

class Searchbar extends StatelessWidget {
   const Searchbar({Key? key, 
    required this.searchController,
    required this.onDone,
    required this.onEdit,
    this.onTap,
  }) : super(key: key);
  final TextEditingController searchController;
  final Function? onTap;
  final Function onEdit;
  final Function onDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Theme.of(context).primaryColorLight),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.background,),
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.name,
          onChanged: (value) {
            onEdit();
          },
          onSubmitted: (value) => onDone,
          onTap: () => onTap != null ? onTap!() : null,
          style: TextStyle(color: Theme.of(context).colorScheme.background),
          controller: searchController,
        ),
      ),
    );
  }
}

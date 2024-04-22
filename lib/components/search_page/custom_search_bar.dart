import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key, required this.searchController, required this.reset});

    final TextEditingController searchController;
    final void Function() reset;


  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    print("Searched Quey inside : ${widget.searchController.text}");
    return SizedBox(
      height: 40,
      child: TextField(
        onChanged: (query) {
          widget.reset();
        },
        controller: widget.searchController,
        style: TextStyle(color: Colors.grey[300]),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey[700],),
          hintText: 'Search Notes...',
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[700], fontSize: 13.5),
          fillColor: Colors.grey[850],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[800]!),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:notility/models/note.dart';
import 'package:notility/extras/note_tag_button.dart';
import 'package:notility/server/mongodb.dart';

class TagsSearch extends StatefulWidget {
  // When searching and adding tags
  const TagsSearch({
    super.key,
    required this.tags,
    required this.noteId,
    required this.refreshNoteTags,
  });

  final List<NoteTag>? tags; // For sending tags if already there
  final String noteId;
  final void Function(List<NoteTag>) refreshNoteTags;

  @override
  State<TagsSearch> createState() => _TagsSearchState();
}

class _TagsSearchState extends State<TagsSearch> {
  final TextEditingController _searchQuery = TextEditingController();
  List<NoteTag> allTags = NoteTag.values;
  List<NoteTag> _searchResults = [];
  List<NoteTag> selectedTags = [];

  @override
  void initState() {
    // Setting tags which already set to note
    super.initState();
    if (widget.tags != null) selectedTags = widget.tags!; // If tags ,ay kuch aur bhi hai toh woh sleected tags may daal do
  }

  void _searchTags(String query) {
    // Returns list of tags that contains the search query
    setState(() {
      query = _searchQuery.text.toLowerCase();
      _searchResults = allTags
          .where((tag) => tag.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void onSelectTags(NoteTag tag) {
    // When a tag is pressed or selected, either add a tag or remove if it is already in the selected tags
    setState(() {
      selectedTags.contains(tag)
          ? selectedTags.remove(tag)
          : selectedTags.add(tag);
    });
  }

  void _onDonePressed() async {
    // When user is done with selecting tags, update them in db and go back
    // print(selectedTags.map((tag) => tag.name));
    await MongoDatabase.updateTags(
      noteId: widget.noteId,
      tags: selectedTags,
    );
    widget.refreshNoteTags(selectedTags);
    Navigator.pop(context);
    setState(() {
      
    });
  }

  @override
  Widget build(context) {

    if (_searchResults.isEmpty) _searchResults = allTags;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 40, 12, 0),
        child: ListView(
          children: [
            Row(
              // Search Bar
              children: [
                Expanded(
                  child: TextField(
                    // Feild for entering query for search
                    controller: _searchQuery,
                    onChanged: _searchTags,
                    decoration: const InputDecoration(
                      hintText: 'Search tags...',
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 16.0,
                      ),
                    ),
                  ),
                ),
      
                const SizedBox(width: 20),
      
                // Done button
                Theme(
                  data: ThemeData(
                    outlinedButtonTheme: Theme.of(context).outlinedButtonTheme
                  ),
                  child: OutlinedButton(
                    // Button for when user is done selecting tags
                    onPressed: _onDonePressed,
                    child: const SizedBox(
                      height: 40,
                      width: 40,
                      child: Center(
                        child: Text(
                          'Done',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
      
            const SearchHeadings(heading: 'Selected'),
      
            // Shows the tags already selected
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: selectedTags.isEmpty
                  ? const Center(
                      child: Text('<Select Tags>',
                          style: TextStyle(
                            color: Colors.grey,
                          )),
                    )
                  : Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                          for (final tag in selectedTags)
                            NoteTagButton(
                              tag: tag,
                              textSize: 12,
                              onSelectTag: onSelectTags,
                              colorTag: Theme.of(context).bottomNavigationBarTheme.selectedIconTheme!.color!,
                            ),
                        ]),
            ),
      
            SizedBox(
              height: selectedTags.isEmpty ? 0 : 40,
            ),
      
            const SearchHeadings(heading: 'Available'),
      
            // Shows all available tags
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 12,
                runSpacing: 8,
                children: [
                  for (final tag in _searchResults)
                    NoteTagButton(
                      tag: tag,
                      textSize: 12,
                      onSelectTag: onSelectTags,
                      colorTag: selectedTags.contains(tag)
                          ? Colors.green
                          : Theme.of(context).bottomNavigationBarTheme.selectedIconTheme!.color!,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchHeadings extends StatelessWidget {
  // Reusable widget. Headings of selected and available tags
  const SearchHeadings({super.key, required this.heading});
  final String heading;

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: const TextStyle(
              fontSize: 12, // Adjust the font size as needed
              fontWeight: FontWeight.bold, // Adjust the font weight as needed
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey, // Choose your color here
                  width: 1.0, // Choose the width of the line
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:notility/components/search_page/custom_search_bar.dart';
import 'package:notility/components/search_page/search_query_type.dart';
import 'package:notility/models/note.dart';
import 'package:notility/widgets/recent_search_section.dart';

DateTime today = DateTime.now();

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.listNotes,
  });

  final List<Note> listNotes;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isRecentSelected = true;

  DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
  DateTime startOfLastMonth = DateTime(today.year, today.month - 1, 1);

  // Separate notes into different lists
  List<Note> notesToday = [];
  List<Note> notesThisWeek = [];
  List<Note> notesLastMonth = [];
  List<Note> searchedByRecent = [];
  List<Note> searchedByCreated = [];

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   initNotes();
  // }

  void reset() {
    if (_searchController.text.isNotEmpty) {
      setSearchedNotes(_searchController.text);
    }
    setState(() {});
  }

  // Sort Notes by Recent and Created
  void setSearchedNotes(String query) {
    searchedByRecent = widget.listNotes
        .where((note) => note.heading!.contains(query))
        .toList();
    searchedByCreated = List.from(searchedByRecent);
    searchedByRecent.sort(((a, b) => b.modifiedAt.compareTo(a.modifiedAt)));
    searchedByCreated.sort(((a, b) => b.createdAt.compareTo(a.createdAt)));
  }

  void toggleSearchType() {
    setState(() {
      isRecentSelected = !isRecentSelected;
    });
  }

  void initNotes() {
    notesToday = [];
    notesThisWeek = [];
    notesLastMonth = [];
    for (Note note in widget.listNotes) {
      if (isSameDay(note.modifiedAt, today)) {
        notesToday.add(note);
      } else if (note.modifiedAt.isAfter(startOfWeek)) {
        if (!isSameDay(note.modifiedAt, today)) {
          notesThisWeek.add(note);
        }
      } else if (note.modifiedAt.isAfter(startOfLastMonth)) {
        if (!isSameDay(note.modifiedAt, today) &&
            !note.modifiedAt.isAfter(startOfWeek)) {
          notesLastMonth.add(note);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    initNotes();
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 38, 12, 12),
          child: Column(
            children: [
              CustomSearchBar(
                searchController: _searchController,
                reset: reset,
              ),
              const SizedBox(height: 24),

              // Show ehen there is nothing in search
              if (_searchController.text.isEmpty) ...[
                if (notesToday.isNotEmpty)
                  RecentSearchSection(heading: 'Today', listNotes: notesToday),
                if (notesThisWeek.isNotEmpty)
                  RecentSearchSection(
                      heading: 'This Week', listNotes: notesThisWeek),
                if (notesLastMonth.isNotEmpty)
                  RecentSearchSection(
                      heading: 'This Month', listNotes: notesLastMonth),
              ] else ...[
                // If there is something in search
                Row(
                  children: [
                    const SizedBox(width: 4),
                    SearchQueryType(
                      heading: 'Recent',
                      isSelected: isRecentSelected,
                      toggleSearchType: toggleSearchType,
                    ),
                    const SizedBox(width: 12),
                    SearchQueryType(
                      heading: 'Created',
                      isSelected: !isRecentSelected,
                      toggleSearchType: toggleSearchType,
                    )
                  ],
                ),
                const SizedBox(height: 28),
                RecentSearchSection(
                    heading: 'Found',
                    listNotes:
                        isRecentSelected ? searchedByRecent : searchedByCreated)
              ],
              const SizedBox(height: 36,)
            ],
          ),
        ),
      ),
    );
  }
}

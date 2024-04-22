import 'package:flutter/material.dart';
import 'package:notility/animations/slide_page.dart';
import 'package:notility/components/search_page/inner_content.dart';
import 'package:notility/models/note.dart';
import 'package:notility/screens/new_note.dart';
import 'package:notility/screens/tabs_screen.dart';

class RecentSearchSection extends StatefulWidget {
  const RecentSearchSection(
      {super.key, required this.heading, required this.listNotes});

  final String heading;
  final List<Note> listNotes;

  @override
  State<RecentSearchSection> createState() => _RecentSearchSectionState();
}

class _RecentSearchSectionState extends State<RecentSearchSection> {
  final int greyColorVal = 41;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Headings
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${widget.heading} (${widget.listNotes.length})',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Outer Decocoration
        Container(
          decoration: BoxDecoration(
            color:
                Color.fromARGB(255, greyColorVal, greyColorVal, greyColorVal),
            border: Border.all(color: Colors.grey[800]!, width: 0.7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              for (int i = 0; i < widget.listNotes.length; i++) ...[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(
                      SlidePageRoute(
                        page: NewNote(
                          note: widget.listNotes[i],
                          // route: widget.listNotes[i].route,
                        ),
                      ),
                    )
                        .then((value) {
                      TabsScreen.of(context)!.updateNote(
                        id: value['updateId'],
                        content: value['content'],
                        heading: value['heading'],
                      );
                    });
                  },
                  child: Container(
                      height: 55,
                      // padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: i != widget.listNotes.length - 1
                                ? Colors.grey[800]!
                                : Colors.transparent,
                          ),
                        ),
                      ),

                      // Inner Content
                      child: InnerContentsSearchPage(
                        note: widget.listNotes[i],
                      )),
                ),
              ]
            ],
          ),
        ),
        const SizedBox(height: 32)
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:notility/animations/slide_page.dart';
import 'package:notility/models/note.dart';
import 'package:notility/screens/tags_search.dart';

class TagsFunctionality extends StatefulWidget {
  const TagsFunctionality({super.key, required this.note});

  final Note note;

  @override
  State<TagsFunctionality> createState() => _TagsFunctionalityState();
}

class _TagsFunctionalityState extends State<TagsFunctionality> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            final List<NoteTag>? updatedTags = await Navigator.of(context).push(
              SlidePageRoute(
                page: TagsSearch(
                  tags: widget.note?.tags ?? [],
                  noteId: widget.note?.id ?? '',
                  refreshNoteTags: (List<NoteTag>? tags) {
                    if (tags != null) {
                      setState(() {
                        widget.note?.tags = tags;
                      });
                    }
                  },
                ),
              ),
            );

            if (updatedTags != null) {
              setState(() {
                widget.note?.tags = updatedTags;
              });
            }
          },
          child: Text(
            '<Add Tags>',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: SizedBox(
            width: 250,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final NoteTag tag in widget.note!.tags ?? []) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                      child: Text(
                        '#${tag.name}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ]
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}


// Positioned(
//                     bottom: 10,
//                     right: 10,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 40),
//                       child: SizedBox(
//                         width: 250,
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: [
//                               for (final NoteTag tag in widget.note!.tags ?? [])
//                                 Chip(
//                                   label: Text(
//                                     tag.name,
//                                     style: const TextStyle(
//                                         fontSize:
//                                             10), // Adjust the fontSize here
//                                   ),
//                                   backgroundColor:
//                                       const Color.fromARGB(255, 33, 163, 243),
//                                   labelStyle:
//                                       const TextStyle(color: Colors.white),
//                                 ),
//                               const SizedBox(width: 8),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 12,
//                     left: 12,
//                     child: GestureDetector(
//                       onTap: () async {
//                         final List<NoteTag>? updatedTags =
//                             await Navigator.of(context).push(
//                           SlidePageRoute(
//                             page: TagsSearch(
//                               tags: widget.note?.tags ?? [],
//                               noteId: widget.note?.id ?? '',
//                               refreshNoteTags: (List<NoteTag>? tags) {
//                                 if (tags != null) {
//                                   setState(() {
//                                     widget.note?.tags = tags;
//                                   });
//                                 }
//                               },
//                             ),
//                           ),
//                         );

//                         if (updatedTags != null) {
//                           setState(() {
//                             widget.note?.tags = updatedTags;
//                           });
//                         }
//                       },
//                       child: Text(
//                         'Add Tags',
//                         style: TextStyle(color: Colors.grey[200]),
//                       ),
//                     ),
//                   ),
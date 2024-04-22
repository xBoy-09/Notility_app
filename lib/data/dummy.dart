// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:notility/animations/slide_page.dart';
// import 'package:notility/models/note.dart';
// import 'package:notility/screens/tags_search.dart';
// import 'package:notility/server/mongodb.dart';

// class NewNote extends StatefulWidget {
//   const NewNote({
//     Key? key,
//     this.isNewNote = false,
//     this.route = '',
//     this.note,
//   }) : super(key: key);

//   final bool isNewNote;
//   final String route;
//   final Note? note;

//   @override
//   State<NewNote> createState() => _NewNoteState();
// }

// class _NewNoteState extends State<NewNote> {
//   final TextEditingController _contentController = TextEditingController();
//   final TextEditingController _headingController = TextEditingController();
//   final FocusNode _contentNode = FocusNode();

//   void _showNoSavingWarning(BuildContext ctx) {
//     showDialog(
//       context: context,
//       builder: ((context) => AlertDialog(
//             backgroundColor: Theme.of(context).colorScheme.background,
//             title: const Text(
//               'Your Note will not be saved.',
//               style: TextStyle(color: Colors.white),
//             ),
//             content: Text(
//               'Yout current Note will not be saved as there is no ${_headingController.text.isEmpty ? 'heading' : 'content'} to your note',
//               style: TextStyle(color: Colors.grey[500]),
//             ),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text('Cancel')),
//               TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     Navigator.pop(ctx);
//                   },
//                   child: const Text(
//                     'Continue anyways',
//                     style: TextStyle(color: Colors.red),
//                   )),
//             ],
//           )),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     if (widget.note != null) updateControllers();
//   }

//   void updateControllers() {
//     _contentController.text = widget.note!.content;
//     _headingController.text = widget.note!.heading!;
//     _contentNode.requestFocus();
//   }

//   String getNotebook(String path) {
//     return path.split('\\').first.trim();
//   }

//   String getSection(String path) {
//     return path.split('\\')[1].trim();
//   }

//   void onPressedBackButton(BuildContext context) {
//     if (_headingController.text.isNotEmpty &&
//         _contentController.text.isNotEmpty) {
//       widget.isNewNote
//           ? MongoDatabase.insertNote(
//               Note(
//                 content: _contentController.text,
//                 userId: FirebaseAuth.instance.currentUser!.uid,
//                 route: widget.route,
//                 notebook: getNotebook(widget.route),
//                 section: getSection(widget.route),
//                 heading: _headingController.text,
//                 tags: [], // Add empty tags for now
//               ),
//             )
//           : MongoDatabase.updateNote(
//               noteId: widget.note!.id,
//               heading: _headingController.text,
//               content: _contentController.text,
//             );
//       Navigator.pop(
//         context,
//         widget.isNewNote
//             ? {
//                 'note': Note(
//                   content: _contentController.text,
//                   userId: FirebaseAuth.instance.currentUser!.uid,
//                   route: widget.route,
//                   notebook: getNotebook(widget.route),
//                   section: getSection(widget.route),
//                   heading: _headingController.text,
//                   tags: [], // Add empty tags for now
//                 ),
//                 'isNew': widget.isNewNote,
//               }
//             : {
//                 'updateId': widget.note!.id,
//                 'heading': _headingController.text,
//                 'content': _contentController.text,
//                 'isNew': widget.isNewNote,
//               },
//       );
//     } else if (_headingController.text.isEmpty &&
//         _contentController.text.isEmpty) {
//       Navigator.pop(context);
//     } else if (_headingController.text.isEmpty ||
//         _contentController.text.isEmpty) {
//       _showNoSavingWarning(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//         toolbarHeight: 48,
//         backgroundColor: Theme.of(context).colorScheme.background,
//         leading: IconButton(
//           onPressed: () => onPressedBackButton(context),
//           icon: const Icon(
//             Icons.arrow_back_ios_new_rounded,
//             color: Colors.white,
//           ),
//         ),
//         leadingWidth: 48,
//         titleSpacing: 0,
//         title: Text(
//           _headingController.text.isEmpty
//               ? 'Heading'
//               : _headingController.text.length > 18
//                   ? '${_headingController.text.substring(0, 18)}...'
//                   : _headingController.text,
//           style: const TextStyle(fontSize: 20, color: Colors.grey),
//         ),
//         actions: [
//           IconButton(
//               onPressed: () {},
//               icon: const Icon(
//                 Icons.share,
//                 color: Colors.white,
//               )),
//           IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.more_horiz_sharp),
//               color: Colors.white),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: Stack(
//           children: [
//             SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.transparent,
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                         left: 12,
//                         right: 12,
//                         top: 6,
//                         bottom: 6,
//                       ),
//                       child: TextField(
//                         autocorrect: true,
//                         onChanged: (text) {
//                           setState(() {});
//                         },
//                         autofocus: true,
//                         maxLines: 1,
//                         controller: _headingController,
//                         style: const TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           hintText: "${"Type your Heading"} ...",
//                           hintStyle: TextStyle(
//                             color: Colors.grey[800],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.transparent,
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                         left: 12,
//                         right: 12,
//                         top: 0,
//                         bottom: 0,
//                       ),
//                       child: TextFormField(
//                         focusNode: _contentNode,
//                         maxLines: null,
//                         controller: _contentController,
//                         style: const TextStyle(
//                           color: Colors.white,
//                         ),
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           hintText: "Type your thoughts...",
//                           hintStyle: TextStyle(
//                             color: Colors.grey[800],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
            
//             Positioned(
//                 bottom: 10,
//                 right: 10,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 40),
//                   child: SizedBox(
//                     width: 250,
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: [
//                           for (final NoteTag tag in widget.note!.tags ?? [])
//                             Chip(
//                               label: Text(
//                                 tag.name,
//                                 style: const TextStyle(fontSize: 10), // Adjust the fontSize here
//                               ),
//                               backgroundColor: const Color.fromARGB(255, 33, 163, 243),
//                               labelStyle: const TextStyle(color: Colors.white),
//                             ),
//                           const SizedBox(width: 8),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//             Positioned(
//               bottom: 12,
//               left: 12,
//               child: GestureDetector(
//                 onTap: () async {
//                   final List<NoteTag>? updatedTags = await Navigator.of(context).push(
//                     SlidePageRoute(
//                       page: TagsSearch(
//                         tags: widget.note?.tags ?? [],
//                         noteId: widget.note?.id ?? '',
//                         refreshNoteTags: (List<NoteTag>? tags) {
//                           if (tags != null) {
//                             setState(() {
//                               widget.note?.tags = tags;
//                             });
//                           }
//                         },
//                       ),
//                     ),
//                   );

//                   if (updatedTags != null) {
//                     setState(() {
//                       widget.note?.tags = updatedTags;
//                     });
//                   }
//                 },
//                 child: Text(
//                   'Add Tags',
//                   style: TextStyle(color: Colors.grey[200]),
//                 ),
//               ),
//             ),

//             Align(
//               alignment: Alignment.topRight,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 34, right: 1),
//                 child: Padding(
//                   padding: const EdgeInsets.all(2.0),
//                   child: Text(
//                     widget.route,
//                     style: TextStyle(
//                         color: Colors.grey[800],
//                         fontSize: 14,
//                         backgroundColor: Colors.grey[900]),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ContentNewNote extends StatefulWidget {
  const ContentNewNote({
    super.key,
    required this.contentNode,
    required this.contentController,
  });

  final FocusNode contentNode;
  final TextEditingController contentController;

  @override
  State<ContentNewNote> createState() => _ContentNewNoteState();
}

class _ContentNewNoteState extends State<ContentNewNote> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // For content editing
      // margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          top: 0,
          bottom: 0,
        ),
        child: TextFormField(
          focusNode: widget.contentNode,
          maxLines: null,
          // expands: true,
          controller: widget.contentController,
          style: const TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Type your thoughts...",
            hintStyle: TextStyle(
              color: Colors.grey[800],
            ),
          ),
        ),
      ),
    );
  }
}

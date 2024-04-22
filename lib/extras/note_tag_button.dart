import 'package:flutter/material.dart';
import 'package:notility/models/note.dart';

class NoteTagButton extends StatefulWidget { // The same note tag as other but this is a button for selecting tags in tags_search. It changed color when pressed
  NoteTagButton({
    super.key,
    required this.tag,
    this.textSize = 10,
    required this.colorTag,
    required this.onSelectTag,
  });

  final NoteTag tag;
  final double textSize;
  final void Function(NoteTag) onSelectTag;
  Color colorTag;

  @override
  State<NoteTagButton> createState() => _NoteTagButtonState();
}

class _NoteTagButtonState extends State<NoteTagButton> {
  void setTag() {}

  @override
  Widget build(context) {
    return InkWell(
      onTap: () {
        widget.onSelectTag(widget.tag);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          shape: BoxShape.rectangle,
          color: widget.colorTag,
        ),
        child: Text(
          widget.tag.name,
          style: TextStyle(
            fontSize: widget.textSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

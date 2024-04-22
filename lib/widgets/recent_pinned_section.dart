import 'package:flutter/material.dart';
import 'package:notility/models/note.dart';
import 'package:notility/widgets/note_card.dart';

class RecentOrPinnedSection extends StatefulWidget {
  const RecentOrPinnedSection({
    super.key,
    required this.listNotes,
    required this.text,
    required this.loading,
  });

  final List<Note> listNotes;
  final String text;
  final bool loading;

  @override
  State<RecentOrPinnedSection> createState() => _RecentOrPinnedSectionState();
}

class _RecentOrPinnedSectionState extends State<RecentOrPinnedSection> {
  bool _isExpanded = true;



  @override
  Widget build(BuildContext context) {
    late Widget showNotes;
    if (widget.listNotes.isEmpty) {
      if (widget.loading) {
        showNotes = Center(
            child: CircularProgressIndicator(
          color: Colors.grey[400],
        ));
      } else {
        showNotes = Center(
          child: Text(
            'No Notes',
            style: TextStyle(color: Colors.grey[600]),
          ),
        );
      }
    } else {
      showNotes = ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.listNotes.length,
        itemBuilder: (context, int index) {
          return NoteCard(
            note: widget.listNotes.elementAt(index),
          );
        },
      );
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Row(
            children: [
              Text(
                widget.text,
                style: TextStyle(color: Colors.grey[500]),
              ),
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                transform: _isExpanded
                    ? Matrix4.rotationZ(3.14 / 2)
                    : Matrix4.rotationZ(0),
                transformAlignment: Alignment.center,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[500],
                  size: 14,
                ),
              ),
            ],
          ),
        ),
        if (!_isExpanded)
          Divider(
            thickness: 0.5,
            color: Colors.grey[widget.text == 'Pinned Notes' ? 800 : 700],
          ),
        // if (_isExpanded)
        AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          height: _isExpanded ? 154 : 0,
          child: showNotes,
        ),
      ],
    );
  }
}

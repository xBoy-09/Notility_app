import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notility/server/mongodb.dart';
import 'package:notility/utils.dart';

class DropDownMove extends StatefulWidget {
  const DropDownMove({
    super.key,
    required this.route,
    this.isNotebook = false,
    required this.listNames,
    required this.setSections,
    this.currentSectionName,
    required this.setNoteBookSection,
  });

  final String route;
  final bool isNotebook;
  final List<String> listNames;
  final void Function(String) setSections;
  final String? currentSectionName;
  final void Function(String, bool) setNoteBookSection;

  @override
  State<DropDownMove> createState() => _DropDownMoveState();
}

class _DropDownMoveState extends State<DropDownMove> {
  late String currentLocation;

  @override
  void initState() {
    super.initState();
    currentLocation = widget.isNotebook
        ? parseNotebookName(widget.route)
        : parseSectionName(widget.route);
  }

  @override
  Widget build(BuildContext context) {
    print('Current Section Name: ${widget.currentSectionName}');
    print('Current Location: $currentLocation');
    if (!widget.isNotebook) {
      widget.setNoteBookSection(
          widget.currentSectionName ?? currentLocation, false);
    }
    return DropdownButton(
      dropdownColor: Colors.grey[800],
      value: widget.currentSectionName ?? currentLocation,
      onChanged: (value) {
        setState(() {
          currentLocation = value.toString();
          if (widget.isNotebook) {
            print('Setting notebook value to : ${value.toString()}');
            widget.setSections(value.toString());
            widget.setNoteBookSection(value.toString(), true);
          } else {
            widget.setNoteBookSection(value.toString(), false);
          }
        });
      },
      items: [
        for (String name in widget.listNames)
          DropdownMenuItem(
            value: name,
            child: Text(
              name,
              style: TextStyle(color: Colors.grey[100]),
            ),
          ),
      ],
    );
  }
}

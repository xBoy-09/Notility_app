import 'package:flutter/material.dart';

class SearchQueryType extends StatelessWidget {
  const SearchQueryType({
    super.key,
    required this.heading,
    required this.isSelected,
    required this.toggleSearchType,
  });

  final String heading;
  final bool isSelected;
  final void Function() toggleSearchType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(!isSelected){
          toggleSearchType();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[isSelected ? 700 : 850],
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: Colors.grey[500]!, width: 0.7) : null,
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            child: Text(
              heading,
              style: TextStyle(color: Colors.grey[100], fontSize: 12),
            )),
      ),
    );
  }
}

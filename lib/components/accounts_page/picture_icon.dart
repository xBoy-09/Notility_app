import 'package:flutter/material.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({super.key, required this.onTap});

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final double _containerTop = 0;


    return Align(
      alignment: Alignment.center,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.grey[850]!,
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignOutside),
              shape: BoxShape.circle,
              color: Colors.grey[800],
            ),
            child: Icon(
              Icons.person,
              size: 130,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 12,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[600],
                ),
                child: Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.grey[900],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

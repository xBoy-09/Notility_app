import 'package:flutter/material.dart';

class RouteTextNewNote extends StatelessWidget {
  const RouteTextNewNote({super.key, required this.route});

  final String route;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 12),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          route,
          style: TextStyle(
              color: Colors.grey[800],
              fontSize: 14,
              backgroundColor: Colors.grey[900]),
        ),
      ),
    );
  }
}

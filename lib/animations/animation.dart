import 'package:flutter/material.dart';

class RecordingInProgressAnimation extends StatefulWidget {
  @override
  _RecordingInProgressAnimationState createState() =>
      _RecordingInProgressAnimationState();
}

class _RecordingInProgressAnimationState
    extends State<RecordingInProgressAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Container(
          color: Theme.of(context).colorScheme.background,
          child: Text(
            'Recording in progress${_getBlinkingDots()}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600], // White text color
            ),
          ),
        );
      },
    );
  }

  String _getBlinkingDots() {
    int dotsCount = (_controller.value * 3).ceil();
    return '.' * dotsCount;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
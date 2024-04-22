import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({super.key, required this.cancelDeleteNoteOption});

  final void Function() cancelDeleteNoteOption;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: SizedBox(
          width: 62,
          height: 36,
          child: OutlinedButton(
            onPressed: () {
              cancelDeleteNoteOption();
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              side: MaterialStateProperty.all<BorderSide>(
                BorderSide(color: Colors.grey[700]!, width: 0),
              ),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.grey[700]!),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

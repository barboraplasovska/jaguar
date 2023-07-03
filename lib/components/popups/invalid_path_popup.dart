import 'package:flutter/material.dart';

class InvalidPathPopup extends StatefulWidget {
  final String path;
  const InvalidPathPopup({
    super.key,
    required this.path,
  });

  @override
  State<InvalidPathPopup> createState() => _InvalidPathPopupState();
}

class _InvalidPathPopupState extends State<InvalidPathPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      content: SizedBox(
        width: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Path does not exist",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "The path '${widget.path}' does not exist.",
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Text("OK"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

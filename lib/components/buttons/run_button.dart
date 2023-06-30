import 'package:flutter/material.dart';

class RunButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RunButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 20,
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      icon: Icon(
        Icons.play_arrow_sharp,
        size: 30,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
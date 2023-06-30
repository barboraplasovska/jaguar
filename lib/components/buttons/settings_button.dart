import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SettingsButton({
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
        Icons.settings_sharp,
        size: 30,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

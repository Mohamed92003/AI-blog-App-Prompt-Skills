import 'package:flutter/material.dart';

class GuestLoginPromptDialog extends StatelessWidget {
  const GuestLoginPromptDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => const GuestLoginPromptDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sign in Required'),
      content: const Text('You need to be logged in to save bookmarks.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Navigate to login screen
            Navigator.of(context).pop(true);
          },
          child: const Text('Sign In'),
        ),
      ],
    );
  }
}

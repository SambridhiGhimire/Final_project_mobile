import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(16),
      title: const Text('Delete Report'),
      content: const Text('Are you sure you want to delete this report?'),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('No', style: TextStyle(color: Colors.black))),
        TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Yes', style: TextStyle(color: Colors.red))),
      ],
    );
  }
}

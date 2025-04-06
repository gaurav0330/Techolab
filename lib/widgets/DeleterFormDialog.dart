import 'package:flutter/material.dart';
import '../models/user_model.dart';

/// Displays a custom animated delete confirmation dialog
void showDeleteConfirmationDialog(
  BuildContext context, {
  required User user,
  required VoidCallback onConfirm,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true, // Dismiss the dialog by tapping outside
    barrierLabel: "Delete Confirmation",
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: _AnimatedDeleteDialog(user: user, onConfirm: onConfirm),
        ),
      );
    },
    // Adds slide and fade transition to the dialog
    transitionBuilder: (_, animation, __, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        )),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}

/// The custom delete dialog widget with animation and confirmation UI
class _AnimatedDeleteDialog extends StatelessWidget {
  final User user;
  final VoidCallback onConfirm;

  const _AnimatedDeleteDialog({
    super.key,
    required this.user,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: theme.dialogBackgroundColor,
      title: const Text(
        'Confirm Delete',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
        'Are you sure you want to delete ${user.firstName}?',
        style: theme.textTheme.bodyMedium,
      ),
      actions: [
        // Cancel button to dismiss dialog
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        // Delete button with confirmation callback
        ElevatedButton.icon(
          icon: const Icon(Icons.delete_forever, size: 18),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
          ),
          onPressed: () {
            onConfirm(); // Call the delete function
            Navigator.of(context).pop(); // Close the dialog
          },
          label: const Text('Delete'),
        ),
      ],
    );
  }
}

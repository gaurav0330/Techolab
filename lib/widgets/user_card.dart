import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'package:intl/intl.dart';

/// A card widget to display user information with edit and delete actions.
class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const UserCard({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Format the user's created date (e.g., "Jan 1, 2025")
    final formattedDate = user.createdAt != null
        ? DateFormat.yMMMd().format(user.createdAt!)
        : null;

    return InkWell(
      onTap: onTap, // Callback when the card is tapped
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: theme.cardColor,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // User Avatar
              CircleAvatar(
                backgroundImage: NetworkImage(user.avatar),
                radius: 24,
              ),
              const SizedBox(width: 12),

              // User details: name, email, job title, created date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full Name
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Email
                    Text(
                      user.email,
                      style: theme.textTheme.bodySmall,
                    ),

                    // Optional spacing if job title or date is available
                    if (user.jobTitle != null || formattedDate != null)
                      const SizedBox(height: 4),

                    // Optional Job Title
                    if (user.jobTitle != null)
                      Text(
                        user.jobTitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.hintColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),

                    // Optional Join Date
                    if (formattedDate != null)
                      Text(
                        'Joined on $formattedDate',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.hintColor,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Edit & Delete buttons
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20, color: Colors.blueAccent),
                    onPressed: onEdit,
                    tooltip: "Edit",
                    splashRadius: 20,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20, color: Colors.redAccent),
                    onPressed: onDelete,
                    tooltip: "Delete",
                    splashRadius: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

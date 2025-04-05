import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';

class UserProfileScreen extends StatelessWidget {
  final User user;

  const UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final formattedDate = user.createdAt != null
        ? DateFormat.yMMMMd().add_jm().format(user.createdAt!)
        : 'Not available';

    return Scaffold(
      appBar: AppBar(
        title: Text('${user.firstName} ${user.lastName}'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user.avatar),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.badge),
                      title: const Text("Job Title"),
                      subtitle: Text(user.jobTitle ?? "Not available"),
                    ),
                    Divider(height: 0),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text("Created At"),
                      subtitle: Text(formattedDate),
                    ),
                    Divider(height: 0),
                    ListTile(
                      leading: const Icon(Icons.perm_identity),
                      title: const Text("User ID"),
                      subtitle: Text('${user.id}'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

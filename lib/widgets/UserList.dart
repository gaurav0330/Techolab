import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'user_card.dart';

/// A responsive widget that displays a list or grid of user cards
/// based on the available screen width. It also supports infinite scrolling
/// and interaction callbacks for edit, delete, and tap actions.
class UserList extends StatelessWidget {
  final List<User> users;
  final ScrollController controller;
  final bool isFetchingMore;
  final Function(User) onEdit;
  final Function(User) onDelete;
  final Function(User) onTap;

  const UserList({
    super.key,
    required this.users,
    required this.controller,
    required this.isFetchingMore,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        final itemCount = isFetchingMore ? users.length + 1 : users.length;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: isWide
              // Display grid view for wider screens (e.g., tablets, desktops)
              ? GridView.builder(
                  key: const ValueKey('grid'),
                  controller: controller,
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3,
                  ),
                  itemCount: itemCount,
                  itemBuilder: (_, index) {
                    if (index == users.length) {
                      // Show loading spinner at end during data fetch
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final user = users[index];
                    return _AnimatedUserCard(
                      key: ValueKey(user.id),
                      user: user,
                      onEdit: () => onEdit(user),
                      onDelete: () => onDelete(user),
                      onTap: () => onTap(user),
                      controller: controller,
                      index: index,
                    );
                  },
                )
              // Fallback to list view for smaller screens (e.g., phones)
              : ListView.builder(
                  key: const ValueKey('list'),
                  controller: controller,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: itemCount,
                  itemBuilder: (_, index) {
                    if (index == users.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final user = users[index];
                    return _AnimatedUserCard(
                      key: ValueKey(user.id),
                      user: user,
                      onEdit: () => onEdit(user),
                      onDelete: () => onDelete(user),
                      onTap: () => onTap(user),
                      controller: controller,
                      index: index,
                    );
                  },
                ),
        );
      },
    );
  }
}

/// A user card widget with a subtle 3D transform effect based on its
/// position relative to the center of the screen for visual enhancement.
class _AnimatedUserCard extends StatelessWidget {
  final User user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final ScrollController? controller;
  final int index;

  const _AnimatedUserCard({
    required Key key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    this.controller,
    this.index = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollOffset = controller?.offset ?? 0;
    final cardHeight = 120.0; // Estimated height of each card
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate the distance from this card to the center of the screen
    final cardTop = index * cardHeight - scrollOffset;
    final centerOffset = (cardTop + cardHeight / 2) - screenHeight / 2;

    // Calculate tilt angle for 3D rotation effect
    final angle = (centerOffset / screenHeight) * 0.5;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Add perspective
        ..rotateX(angle),       // Apply vertical tilt
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: UserCard(
          user: user,
          onEdit: onEdit,
          onDelete: onDelete,
          onTap: onTap,
        ),
      ),
    );
  }
}

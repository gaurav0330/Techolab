import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'user_card.dart';

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
    final cardHeight = 120.0; // Adjust based on your card's height
    final screenHeight = MediaQuery.of(context).size.height;

    // Distance of this card from center
    final cardTop = index * cardHeight - scrollOffset;
    final centerOffset = (cardTop + cardHeight / 2) - screenHeight / 2;
    final angle = (centerOffset / screenHeight) * 0.5; // max ~0.5 radians (~28 deg)

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // perspective
        ..rotateX(angle),
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


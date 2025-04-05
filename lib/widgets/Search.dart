import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  final ValueChanged<String> onSearch;

  const Search({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: TextField(
          onChanged: onSearch,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Search by name or email...',
            hintStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
            prefixIcon: const Icon(Icons.search),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }
}

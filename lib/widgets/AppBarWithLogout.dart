import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

/// A reusable AppBar widget with title, theme toggle, and logout button.
class AppBarWithLogout extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onLogout;

  const AppBarWithLogout({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return AppBar(
      elevation: 2,
      title: const Text(
        'User Management',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      actions: [
        Row(
          children: [
            // Theme icon that switches based on current mode
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return RotationTransition(turns: animation, child: child);
              },
              child: Icon(
                isDark ? Icons.nights_stay : Icons.wb_sunny,
                key: ValueKey<bool>(isDark),
                color: Colors.yellow[700],
              ),
            ),

            // Toggle switch to switch between light and dark mode
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: themeProvider.toggleTheme,
                );
              },
            ),

            // Logout icon button
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: onLogout,
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Defines the preferred size for the AppBar.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

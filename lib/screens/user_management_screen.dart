import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';

import '../widgets/user_card.dart';
import '../widgets/UserFormDialog.dart';
import '../widgets/search.dart';
import '../widgets/UserList.dart';
import '../widgets/DeleterFormDialog.dart';

import './login_screen.dart';
import './user_profile_screen.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Infinite scroll to fetch more users
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !userProvider.isFetchingMore &&
          userProvider.hasMore) {
        userProvider.fetchUsers();
      }
    });

    // Fetch initial users after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userProvider.fetchInitialUsers();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Show user form for add/edit
  void _showUserForm({User? user}) async {
    final result = await showDialog<User>(
      context: context,
      builder: (_) => UserFormDialog(user: user),
    );

    if (result != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.addOrUpdateUser(result, isNew: user == null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(user == null ? 'User added' : 'User updated')),
      );
    }
  }

  // Confirm user deletion
  void _confirmDelete(User user) {
    showDeleteConfirmationDialog(
      context,
      user: user,
      onConfirm: () async {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.deleteUser(user.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted')),
        );
      },
    );
  }

  // Logout and navigate to login screen
  void _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            actions: [
              Row(
                children: [
                  // Theme toggle switch
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) => Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: themeProvider.toggleTheme,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: _logout,
                  ),
                ],
              ),
            ],
          ),
          body: userProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Search and sort
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Search(
                                onSearch: userProvider.search,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                constraints: const BoxConstraints(maxWidth: 160),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade400),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: userProvider.sortBy,
                                    onChanged: (value) {
                                      if (value != null) {
                                        userProvider.setSortBy(value);
                                      }
                                    },
                                    icon: Icon(Icons.sort,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color),
                                    dropdownColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    isExpanded: true,
                                    items: const [
                                      DropdownMenuItem(
                                          value: 'Name',
                                          child: Text('Sort by Name')),
                                      DropdownMenuItem(
                                          value: 'Email',
                                          child: Text('Sort by Email')),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // User list with pull-to-refresh
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: userProvider.refreshUsers,
                            child: UserList(
                              controller: _scrollController,
                              users: userProvider.users,
                              isFetchingMore: userProvider.isFetchingMore,
                              onEdit: (user) => _showUserForm(user: user),
                              onDelete: _confirmDelete,
                              onTap: (user) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UserProfileScreen(user: user),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
          // Add user button
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showUserForm(),
            icon: const Icon(Icons.add),
            label: const Text('Add User'),
          ),
        );
      },
    );
  }
}

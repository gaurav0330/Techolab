import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  // Internal state
  List<User> _users = [];
  List<User> _filteredUsers = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _isFetchingMore = false;
  bool _hasMore = true;
  String _searchQuery = '';
  String _sortBy = 'Name';

  // Getters
  String get sortBy => _sortBy;
  List<User> get users => _filteredUsers;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _hasMore;

  // Fetch first page of users
  Future<void> fetchInitialUsers() async {
    _currentPage = 1;
    _hasMore = true;
    _users = [];
    _filteredUsers = [];
    await fetchUsers();
  }

  // Fetch paginated users
  Future<void> fetchUsers() async {
    if (_isFetchingMore || !_hasMore) return;

    _isFetchingMore = true;
    notifyListeners();

    try {
      final newUsers = await _userService.fetchUsers(page: _currentPage);
      if (newUsers.isEmpty) {
        _hasMore = false;
      } else {
        _users.addAll(newUsers);
        _currentPage++;
        _applySearch(); // Apply current search and sorting
      }
    } catch (e) {
      debugPrint('Error fetching users: $e');
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  // Update search query and filter users
  void search(String query) {
    _searchQuery = query;
    _applySearch();
  }

  // Update sorting option
  void setSortBy(String value) {
    _sortBy = value;
    _applySearch();
  }

  // Apply current search and sorting logic
  void _applySearch() {
    _filteredUsers = _users
        .where((user) =>
            user.firstName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            user.lastName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            user.email.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
    _sortUsers();
    notifyListeners();
  }

  // Sort users based on selected option
  void _sortUsers() {
    _filteredUsers.sort((a, b) {
      switch (_sortBy) {
        case 'Email':
          return a.email.compareTo(b.email);
        default:
          return (a.firstName + a.lastName).compareTo(b.firstName + b.lastName);
      }
    });
  }

  // Reload all user data
  Future<void> refreshUsers() async {
    _users.clear();
    _filteredUsers.clear();
    _currentPage = 1;
    _hasMore = true;
    await fetchUsers();
  }

  // Add new user or update existing user
  Future<void> addOrUpdateUser(User user, {bool isNew = true}) async {
    if (isNew) {
      _users.add(user);
    } else {
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) _users[index] = user;
    }
    _applySearch();
  }

  // Delete user by ID
  Future<void> deleteUser(int id) async {
    await _userService.deleteUser(id);
    _users.removeWhere((user) => user.id == id);
    _applySearch();
  }
}

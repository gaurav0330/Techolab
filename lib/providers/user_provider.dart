import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  List<User> _users = [];
  List<User> _filteredUsers = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _isFetchingMore = false;
  bool _hasMore = true;
  String _searchQuery = '';
  String _sortBy = 'Name';
  String get sortBy => _sortBy;

  List<User> get users => _filteredUsers;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _hasMore;

  Future<void> fetchInitialUsers() async {
    _currentPage = 1;
    _hasMore = true;
    _users = [];
    _filteredUsers = [];
    await fetchUsers();
  }


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
        _applySearch();
      }
    } catch (e) {
      debugPrint('Error fetching users: $e');
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query;
    _applySearch();
  }

  void setSortBy(String value) {
    _sortBy = value;
    _applySearch();
  }

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

  Future<void> refreshUsers() async {
    _users.clear();
    _filteredUsers.clear();
    _currentPage = 1;
    _hasMore = true;
    await fetchUsers();
  }

  Future<void> addOrUpdateUser(User user, {bool isNew = true}) async {
    if (isNew) {
      _users.add(user);
    } else {
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) _users[index] = user;
    }
    _applySearch();
  }

  Future<void> deleteUser(int id) async {
    await _userService.deleteUser(id);
    _users.removeWhere((user) => user.id == id);
    _applySearch();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/guest_book/guest_book_bloc.dart';
import '../bloc/guest_book/guest_book_event.dart';
import '../bloc/guest_book/guest_book_state.dart';
import '../widgets/guest_book_list.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Load initial data
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadData() {
    context.read<GuestBookBloc>().add(GuestBookLoadOfflineRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guest Book'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Sync button
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Sync Data',
            onPressed: () => _showSyncDialog(),
          ),
          // Profile button
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () => context.go('/main/guest-biodata'),
          ),
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _showLogoutDialog(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          onTap: (index) {
            if (index == 0) {
              context.read<GuestBookBloc>().add(GuestBookLoadOfflineRequested());
            } else {
              context.read<GuestBookBloc>().add(GuestBookLoadOnlineRequested());
            }
          },
          tabs: const [
            Tab(
              icon: Icon(Icons.storage),
              text: 'Offline Data',
            ),
            Tab(
              icon: Icon(Icons.cloud),
              text: 'Online Data',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Status indicator
          BlocBuilder<GuestBookBloc, GuestBookState>(
            builder: (context, state) {
              if (state is GuestBookListLoaded) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: state.isOffline ? Colors.orange[100] : Colors.green[100],
                  child: Row(
                    children: [
                      Icon(
                        state.isOffline ? Icons.storage : Icons.cloud,
                        size: 16,
                        color: state.isOffline ? Colors.orange[700] : Colors.green[700],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.isOffline 
                          ? 'Showing offline data (${state.guestBooks.length} entries)'
                          : 'Showing online data (${state.guestBooks.length} entries)',
                        style: TextStyle(
                          color: state.isOffline ? Colors.orange[700] : Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                GuestBookList(isOffline: true),
                GuestBookList(isOffline: false),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/main/add-guest-book'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Entry'),
      ),
    );
  }

  void _showSyncDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sync Data'),
          content: const Text('Choose sync direction:'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<GuestBookBloc>().add(GuestBookSyncToOnlineRequested());
                _showSnackBar('Syncing to online...');
              },
              child: const Text('To Online'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<GuestBookBloc>().add(GuestBookSyncToOfflineRequested());
                _showSnackBar('Syncing to offline...');
              },
              child: const Text('To Offline'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<GuestBookBloc>().add(GuestBookFullSyncRequested());
                _showSnackBar('Full sync in progress...');
              },
              child: const Text('Full Sync'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
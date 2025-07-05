import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../bloc/guest_book/guest_book_bloc.dart';
import '../bloc/guest_book/guest_book_state.dart';
import '../models/guest_book.dart';

class GuestBookList extends StatelessWidget {
  final bool isOffline;

  const GuestBookList({
    super.key,
    required this.isOffline,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GuestBookBloc, GuestBookState>(
      builder: (context, state) {
        if (state is GuestBookLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is GuestBookListLoaded) {
          if (state.guestBooks.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              // Trigger refresh based on current tab
              if (isOffline) {
                context.read<GuestBookBloc>().add(GuestBookLoadOfflineRequested());
              } else {
                context.read<GuestBookBloc>().add(GuestBookLoadOnlineRequested());
              }
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.guestBooks.length,
              itemBuilder: (context, index) {
                final guestBook = state.guestBooks[index];
                return _buildGuestBookCard(context, guestBook);
              },
            ),
          );
        }

        if (state is GuestBookError) {
          return _buildErrorState(context, state.message);
        }

        if (state is GuestBookSyncSuccess) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (isOffline) {
                      context.read<GuestBookBloc>().add(GuestBookLoadOfflineRequested());
                    } else {
                      context.read<GuestBookBloc>().add(GuestBookLoadOnlineRequested());
                    }
                  },
                  child: const Text('Reload Data'),
                ),
              ],
            ),
          );
        }

        return _buildEmptyState();
      },
    );
  }

  Widget _buildGuestBookCard(BuildContext context, GuestBook guestBook) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          if (guestBook.guestBiodata?.id != null) {
            context.go('/main/guest-detail/${guestBook.guestBiodata!.id}');
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with guest name and date
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      _getInitials(guestBook.guestBiodata?.fullName ?? 'Unknown'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          guestBook.guestBiodata?.fullName ?? 'Unknown Guest',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (guestBook.guestBiodata?.email != null)
                          Text(
                            guestBook.guestBiodata!.email!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    _formatDate(guestBook.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Message content
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(
                  guestBook.message,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      if (guestBook.guestBiodata?.id != null) {
                        context.go('/main/guest-detail/${guestBook.guestBiodata!.id}');
                      }
                    },
                    icon: const Icon(Icons.person, size: 16),
                    label: const Text('View Profile'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isOffline ? Icons.storage : Icons.cloud_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            isOffline 
              ? 'No offline guest book entries yet'
              : 'No online guest book entries found',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first entry',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading data',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (isOffline) {
                context.read<GuestBookBloc>().add(GuestBookLoadOfflineRequested());
              } else {
                context.read<GuestBookBloc>().add(GuestBookLoadOnlineRequested());
              }
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'U';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM dd, yyyy').format(date);
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'bloc/auth/auth_bloc.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/add_guest_book_screen.dart';
import 'screens/guest_detail_screen.dart';
import 'screens/guest_biodata_screen.dart';
import 'screens/detailed_guest_info_screen.dart';

class GuestBookApp extends StatelessWidget {
  const GuestBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Guest Book App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
      routerConfig: _createRouter(context),
    );
  }

  GoRouter _createRouter(BuildContext context) {
    return GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        final authState = context.read<AuthBloc>().state;
        final isAuthenticated = authState is AuthAuthenticated;
        final isLoggingIn = state.location == '/login';

        if (!isAuthenticated && !isLoggingIn) {
          return '/login';
        }
        if (isAuthenticated && isLoggingIn) {
          return '/main';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/main',
          builder: (context, state) => const MainScreen(),
          routes: [
            GoRoute(
              path: 'guest-detail/:id',
              builder: (context, state) => GuestDetailScreen(
                guestId: int.parse(state.pathParameters['id']!),
              ),
            ),
            GoRoute(
              path: 'add-guest-book',
              builder: (context, state) => const AddGuestBookScreen(),
            ),
            GoRoute(
              path: 'guest-biodata',
              builder: (context, state) => const GuestBiodataScreen(),
              routes: [
                GoRoute(
                  path: 'detailed-info',
                  builder: (context, state) => const DetailedGuestInfoScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
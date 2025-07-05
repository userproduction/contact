import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'repositories/auth_repository.dart';
import 'repositories/guest_repository.dart';
import 'repositories/guest_book_repository.dart';
import 'services/database_service.dart';
import 'services/api_service.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/guest/guest_bloc.dart';
import 'bloc/guest_book/guest_book_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  final sharedPreferences = await SharedPreferences.getInstance();
  final databaseService = DatabaseService();
  await databaseService.initDatabase();
  
  final apiService = ApiService();
  
  // Initialize repositories
  final authRepository = AuthRepository(
    apiService: apiService,
    sharedPreferences: sharedPreferences,
  );
  
  final guestRepository = GuestRepository(
    apiService: apiService,
    databaseService: databaseService,
  );
  
  final guestBookRepository = GuestBookRepository(
    apiService: apiService,
    databaseService: databaseService,
  );
  
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: guestRepository),
        RepositoryProvider.value(value: guestBookRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(AuthCheckRequested()),
          ),
          BlocProvider(
            create: (context) => GuestBloc(
              guestRepository: context.read<GuestRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => GuestBookBloc(
              guestBookRepository: context.read<GuestBookRepository>(),
            ),
          ),
        ],
        child: const GuestBookApp(),
      ),
    ),
  );
}
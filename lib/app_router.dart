import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:procrew_task/business_logic/auth/auth_cubit.dart';
import 'package:procrew_task/data/repository/auth_repository.dart';
import 'package:procrew_task/presentation/screens/recordings_screen.dart';

import 'constants/strings.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/signup_screen.dart';

class AppRouter {
  late AuthRepository authRepository;
  late AuthCubit authCubit;

  AppRouter() {
    authRepository = FirebaseAuthRepository();
    authCubit = AuthCubit(authRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthCubit(authRepository),
            child: LoginScreen(),
          ),
        );
      case signupScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthCubit(authRepository),
            child: SignUpScreen(),
          ),
        );
      case recordingsScreen:
        return MaterialPageRoute(
          builder: (_) => RecordingsScreen(),
        );
    }
  }
}

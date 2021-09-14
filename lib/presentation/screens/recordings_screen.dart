import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:procrew_task/business_logic/auth/auth_cubit.dart';
import 'package:procrew_task/constants/my_colors.dart';
import 'package:procrew_task/constants/strings.dart';
import 'package:procrew_task/data/repository/auth_repository.dart';
import 'package:procrew_task/presentation/widgets/custom_elevated_button.dart';

class RecordingsScreen extends StatelessWidget {
  late AuthRepository authRepository;
  late AuthCubit authCubit;

  RecordingsScreen(){
    authRepository = FirebaseAuthRepository();
    authCubit = AuthCubit(authRepository);
  }

  Widget _buildLoginButton(BuildContext context) {
    return CustomElevatedButton(
        width: 100,
        height: 50,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(MyColors.myBlue),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text(
          "Logout",
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () async {
          await authCubit.logout();
          Navigator.of(context).pushReplacementNamed(loginScreen);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(authRepository),
            child: _buildLoginButton(context),
          ),
        ),
      ),
    );
  }
}

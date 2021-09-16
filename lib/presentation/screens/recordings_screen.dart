import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:procrew_task/business_logic/auth/auth_cubit.dart';
import 'package:procrew_task/constants/my_colors.dart';
import 'package:procrew_task/constants/strings.dart';
import 'package:procrew_task/data/repository/auth_repository.dart';
import 'package:procrew_task/presentation/widgets/custom_elevated_button.dart';
import 'package:procrew_task/presentation/widgets/recording_buttons.dart';
import 'package:procrew_task/presentation/widgets/recording_list.dart';

class RecordingsScreen extends StatefulWidget {
  late AuthRepository authRepository;
  late AuthCubit authCubit;

  RecordingsScreen() {
    authRepository = FirebaseAuthRepository();
    authCubit = AuthCubit(authRepository);
  }

  @override
  _RecordingsScreenState createState() => _RecordingsScreenState();
}

class _RecordingsScreenState extends State<RecordingsScreen> {
  List<Reference> references = [];

  @override
  void initState() {
    _onUploadComplete();
    super.initState();
  }

  Future<void> _onUploadComplete() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    ListResult listResult =
        await firebaseStorage.ref().child('recordings').list();
    setState(() {
      references = listResult.items;
    });
  }

  Widget _buildLogoutButton(BuildContext context) {
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
          await widget.authCubit.logout();
          Navigator.of(context).pushReplacementNamed(loginScreen);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recordings Screen',
          style: TextStyle(color: MyColors.myNavyBlue),
        ),
        backgroundColor: MyColors.myGrey,
        actions: [
          Container(
            padding: EdgeInsets.all(8),
            child: BlocProvider<AuthCubit>(
              create: (context) => AuthCubit(widget.authRepository),
              child: _buildLogoutButton(context),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              color: MyColors.myNavyBlue,
              child: Text(
                "Swipe left to delete a voice record",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: references.isEmpty
                  ? Center(
                      child: Text(
                        'No files uploaded yet',
                        style: TextStyle(
                          color: MyColors.myNavyBlue,
                          fontSize: 22,
                        ),
                      ),
                    )
                  : RecordingsList(
                      references: references,
                    ),
            ),
            Expanded(
              flex: 1,
              child: RecodingButtonsWidget(
                onUploadComplete: _onUploadComplete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

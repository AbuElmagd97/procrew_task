import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:procrew_task/app_router.dart';
import 'package:procrew_task/constants/strings.dart';


late String initialRoute;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseAuth.instance.authStateChanges().listen((user) {
    if(user == null){
      initialRoute = loginScreen;
    }
    else {
      initialRoute = recordingsScreen;
    }
  });
  runApp(ProCrewTask(
    appRouter: AppRouter(),
  ));
}

class ProCrewTask extends StatelessWidget {
  final AppRouter appRouter;

  const ProCrewTask({Key? key, required this.appRouter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: initialRoute,
    );
  }
}

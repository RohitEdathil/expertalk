import 'package:expertalk/expert_or_participant/expert_or_participant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const Expertalk());
}

class Expertalk extends StatelessWidget {
  const Expertalk({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ExpertOrParticipant(),
      theme: ThemeData(
        colorScheme: ColorScheme(
          primary: Colors.blue.shade300,
          primaryVariant: Colors.blue.shade900,
          secondary: Colors.purple,
          secondaryVariant: Colors.purple.shade900,
          surface: Colors.white,
          background: Colors.white,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.deepPurple.shade900,
          onBackground: Colors.deepPurple.shade900,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
      ),
    );
  }
}

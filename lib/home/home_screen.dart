import 'package:expertalk/expert_or_participant/expert_or_participant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _logout(BuildContext context) {
    FirebaseAuth.instance.signOut().then((value) => Navigator.of(context)
        .pushReplacement(PageTransition(
            child: const ExpertOrParticipant(),
            type: PageTransitionType.topToBottom)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        onPressed: () => _logout(context),
        child: const Text("Logout"),
      )),
    );
  }
}

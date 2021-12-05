import 'package:expertalk/components/chooser/chooser.dart';
import 'package:expertalk/components/wide_button/wide_button.dart';
import 'package:expertalk/login/login.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ExpertOrParticipant extends StatefulWidget {
  const ExpertOrParticipant({Key? key}) : super(key: key);

  @override
  State<ExpertOrParticipant> createState() => _ExpertOrParticipantState();
}

class _ExpertOrParticipantState extends State<ExpertOrParticipant> {
  Role selected = Role.participant;

  void _switch(n) {
    selected = n == 0 ? Role.participant : Role.expert;
  }

  void _next() {
    Navigator.of(context).push(PageTransition(
      child: LoginScreen(role: selected),
      type: PageTransitionType.rightToLeftWithFade,
      curve: Curves.easeIn,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 140),
            child: Text(
              "Select Role",
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: 40,
                  ),
            ),
          ),
          DataChooser(
              background: Theme.of(context).cardColor,
              foreground: Theme.of(context).primaryColor,
              callback: _switch),
          WideButton(callback: _next, text: "Next")
        ],
      ),
    );
  }
}

enum Role { participant, expert }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expertalk/ask/ask.dart';
import 'package:expertalk/expert_or_participant/expert_or_participant.dart';
import 'package:expertalk/home/dashboard.dart';
import 'package:expertalk/home/question_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selected = 0;
  final _pageController = PageController();
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  void _logout(BuildContext context) {
    FirebaseAuth.instance.signOut().then((value) => Navigator.of(context)
        .pushReplacement(PageTransition(
            child: const ExpertOrParticipant(),
            type: PageTransitionType.topToBottom)));
  }

  void _setPage(n) {
    _pageController.animateToPage(n,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    setState(() => selected = n);
  }

  void _ask(BuildContext context) async {
    await Navigator.of(context).push(PageTransition(
        child: const AskScreen(), type: PageTransitionType.bottomToTop));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: db.collection("users").doc(user!.uid).get(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Scaffold(
                  body: const Center(child: CircularProgressIndicator()),
                  backgroundColor: Theme.of(context).cardColor,
                )
              : Scaffold(
                  floatingActionButton:
                      snapshot.data!.data()!['role'] == "participant"
                          ? FloatingActionButton(
                              backgroundColor: Theme.of(context).primaryColor,
                              onPressed: () => _ask(context),
                              child: const Icon((Icons.add_rounded)),
                            )
                          : null,
                  bottomNavigationBar: BottomNavigationBar(
                    backgroundColor: Theme.of(context).cardColor,
                    currentIndex: selected,
                    onTap: _setPage,
                    elevation: 0,
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home_rounded), label: "Home"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.question_answer_rounded),
                          label: "Questions"),
                    ],
                  ),
                  backgroundColor: Theme.of(context).cardColor,
                  appBar: AppBar(
                    elevation: 0,
                    title: Text(
                      "Hi, " + snapshot.data!.data()!["name"],
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    backgroundColor: Theme.of(context).cardColor,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.power_settings_new_rounded,
                            color: Theme.of(context).backgroundColor,
                            size: 30,
                          ),
                          onPressed: () => _logout(context),
                        ),
                      )
                    ],
                  ),
                  body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      future: snapshot.data!.data()!["role"] == "expert"
                          ? db
                              .collection("questions")
                              .where('topic',
                                  isEqualTo: snapshot.data!.data()!["topic"])
                              .get()
                          : db
                              .collection("questions")
                              .where("by", isEqualTo: user!.uid)
                              .get(),
                      builder: (context, snapshot2) {
                        return !snapshot2.hasData
                            ? const Center(child: CircularProgressIndicator())
                            : PageView(
                                controller: _pageController,
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  Dashboard(
                                      data: snapshot.data!.data()!,
                                      questions: snapshot2.data!.docs),
                                  QuestionList(
                                    uid: user!.uid,
                                    questions: snapshot2.data!.docs,
                                    role: snapshot.data!.data()!['role'],
                                    refresh: () => setState(() {}),
                                  ),
                                ],
                                onPageChanged: _setPage,
                              );
                      }),
                );
        });
  }
}

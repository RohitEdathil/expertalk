import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expertalk/answer/answer.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class QuestionList extends StatefulWidget {
  final String uid;
  final String role;
  final VoidCallback refresh;
  final List<DocumentSnapshot<Map<String, dynamic>>> questions;
  const QuestionList(
      {Key? key,
      required this.uid,
      required this.questions,
      required this.refresh,
      required this.role})
      : super(key: key);

  @override
  State<QuestionList> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  void _answer(String id, String ques, BuildContext context) async {
    await Navigator.of(context).push(PageTransition(
        child: AnswerScreen(question: ques, id: id),
        type: PageTransitionType.bottomToTop));
    widget.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.questions.length,
        itemBuilder: (context, n) {
          final question = widget.questions[n].data()!;
          return ExpansionTile(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  question["answered"] ? question['answer'] : "~ nil ~",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              widget.role == "expert" && !question["answered"]
                  ? OutlinedButton(
                      onPressed: () => _answer(widget.questions[n].id,
                          question['question'], context),
                      child: const Text("Answer Now"))
                  : const SizedBox()
            ],
            leading: question["answered"]
                ? const Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : const Icon(Icons.access_time),
            title: Text(
              question['question'],
              style: const TextStyle(fontSize: 20),
            ),
          );
        });
  }
}

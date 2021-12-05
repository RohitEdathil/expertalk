import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnswerScreen extends StatefulWidget {
  final String id;
  final String question;
  const AnswerScreen({Key? key, required this.id, required this.question})
      : super(key: key);

  @override
  _AnswerScreenState createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  final _answerController = TextEditingController();
  var loading = false;

  void _ask() async {
    if (_answerController.text == '') {
      return;
    }
    setState(() => loading = true);
    (await FirebaseFirestore.instance
        .collection("questions")
        .doc(widget.id)
        .update({"answer": _answerController.text, "answered": true}));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: loading ? null : _ask,
        child: loading
            ? CircularProgressIndicator(
                color: Theme.of(context).cardColor,
              )
            : const Icon(Icons.check),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Answer",
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(color: Theme.of(context).primaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SelectableText(
                widget.question,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              Center(
                child: TextField(
                  autofocus: true,
                  controller: _answerController,
                  scrollPhysics: const BouncingScrollPhysics(),
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.grey),
                  maxLines: 20,
                  minLines: 20,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AskScreen extends StatefulWidget {
  const AskScreen({Key? key}) : super(key: key);

  @override
  _AskScreenState createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> {
  final _questionController = TextEditingController();
  var loading = false;
  List<String> topicList = [];
  int selected = 0;
  List<Widget> _renderTopics(Map topics) {
    List<Widget> result = [];
    for (var topic in topics["0"]) {
      topicList.add(topic);
      result.add(Center(
          child: SizedBox(
              child: Text(
        topic.toString(),
        style: Theme.of(context)
            .textTheme
            .headline5!
            .copyWith(color: Theme.of(context).primaryColor),
      ))));
    }
    return result;
  }

  void _selectTopic(n) => selected = n;

  void _ask() async {
    if (_questionController.text == '') {
      return;
    }
    setState(() => loading = true);
    await FirebaseFirestore.instance.collection("questions").add({
      'question': _questionController.value.text,
      'answered': false,
      'by': FirebaseAuth.instance.currentUser!.uid,
      'topic': topicList[selected]
    });
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
          "Ask a Question",
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(color: Theme.of(context).primaryColor),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                controller: _questionController,
                textAlign: TextAlign.center,
                scrollPhysics: const BouncingScrollPhysics(),
                style: Theme.of(context).textTheme.headline1!.copyWith(
                    fontSize: 50, color: Theme.of(context).primaryColor),
                maxLines: 3,
                minLines: 1,
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection("topics")
                  .doc("0")
                  .get(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          Text(
                            "Swipe up to choose topic",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 12),
                          ),
                          CupertinoPicker(
                              looping: true,
                              itemExtent: 80,
                              onSelectedItemChanged: _selectTopic,
                              children: _renderTopics(snapshot.data!.data()!)),
                        ],
                      );
              })
        ],
      ),
    );
  }
}

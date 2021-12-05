import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Dashboard extends StatelessWidget {
  final Map data;
  final List<DocumentSnapshot<Map<String, dynamic>>> questions;
  const Dashboard({Key? key, required this.data, required this.questions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int total = questions.length;
    int done = 0;
    for (var q in questions) {
      if (q['answered']) {
        done += 1;
      }
    }
    bool expert = data["role"] == "expert";
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: const EdgeInsets.all(30),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  expert ? "Topic" : "Currently attending",
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Theme.of(context).cardColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                Divider(
                  height: 30,
                  thickness: 3,
                  color: Theme.of(context).cardColor,
                ),
                Text(
                  data[expert ? "topic" : "hackathon"],
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Theme.of(context).cardColor),
                ),
              ],
            ),
          ),
          CircularPercentIndicator(
            radius: 200,
            lineWidth: 15,
            progressColor: Theme.of(context).primaryColor,
            animation: true,
            center: Text(
              "${(done * 100 / total).round()}%",
              style: Theme.of(context).textTheme.headline3!.copyWith(
                  color: Theme.of(context).colorScheme.primaryVariant),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            percent: done / total,
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Asked",
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      total.toString(),
                      style: TextStyle(
                        fontSize: 54,
                        color: Theme.of(context).colorScheme.primaryVariant,
                      ),
                    ),
                  ],
                ),
                FractionallySizedBox(
                    heightFactor: 0.7,
                    child: Container(
                      width: 3,
                      color: Theme.of(context).dividerColor,
                    )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Answers",
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      done.toString(),
                      style: TextStyle(
                        fontSize: 50,
                        color: Theme.of(context).colorScheme.primaryVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

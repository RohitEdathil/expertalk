import 'package:flutter/material.dart';

class ChoiceBG extends StatelessWidget {
  final String name;
  final String emoji;
  final Color fg;
  const ChoiceBG(
      {Key? key, required this.fg, required this.emoji, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 40),
          ),
          Text(
            name,
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: fg, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

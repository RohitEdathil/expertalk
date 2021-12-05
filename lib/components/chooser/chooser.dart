import 'package:expertalk/components/chooser/choice_background.dart';
import 'package:flutter/material.dart';

class DataChooser extends StatefulWidget {
  final Color background;
  final Color foreground;
  final Function(int) callback;
  const DataChooser(
      {Key? key,
      required this.background,
      required this.foreground,
      required this.callback})
      : super(key: key);

  @override
  _DataChooserState createState() => _DataChooserState();
}

class _DataChooserState extends State<DataChooser> {
  int selected = 0;
  bool first = true;

  void _switch() {
    setState(() {
      selected = selected == 0 ? 1 : 0;
      widget.callback(selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: _switch,
          child: Container(
            color: Colors.transparent,
            height: 180,
            width: 360,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ChoiceBG(
                    fg: widget.foreground, emoji: "🏅", name: "Participant"),
                ChoiceBG(fg: widget.foreground, emoji: "👨‍🎓", name: "Expert"),
              ],
            ),
          ),
        ),
        TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            tween: Tween<double>(
                end: selected.toDouble(), begin: selected == 0 ? 1.0 : 0.0),
            builder: (context, val, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 180 * val),
                  Container(
                    decoration: BoxDecoration(
                      color: widget.foreground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 180,
                    width: 180,
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 1 - val,
                          child: ChoiceBG(
                            fg: widget.background,
                            emoji: "🏅",
                            name: "Participant",
                          ),
                        ),
                        Opacity(
                          opacity: val,
                          child: ChoiceBG(
                            fg: widget.background,
                            emoji: "👨‍🎓",
                            name: "Expert",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ],
    );
  }
}

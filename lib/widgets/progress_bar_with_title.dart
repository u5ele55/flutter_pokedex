import 'package:flutter/material.dart';

class ProgressBarWithTitle extends StatelessWidget {
  const ProgressBarWithTitle(
      {Key? key,
      this.title = "",
      this.value = "",
      this.progress = 0,
      this.color})
      : super(key: key);

  final String title;
  final String value;
  final double progress;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, letterSpacing: 1),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 16, letterSpacing: 1),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Container(
          width: double.infinity,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: LinearProgressIndicator(
              color: color,
              value: progress,
              backgroundColor: (color ?? Colors.black).withAlpha(128),
              minHeight: 10,
            ),
          ),
        ),
      ],
    );
  }
}

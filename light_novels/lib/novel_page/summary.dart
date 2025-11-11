import 'package:flutter/material.dart';

class NovelSummary extends StatelessWidget {
  final String text;
  const NovelSummary({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}

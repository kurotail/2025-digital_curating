import 'package:flutter/material.dart';

class NovelQuoteBox extends StatelessWidget {
  final String text;
  const NovelQuoteBox({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Theme.of(context).colorScheme.primary, width: 4),
        ),
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "“ $text ”",
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontStyle: FontStyle.italic),
      ),
    );
  }
}

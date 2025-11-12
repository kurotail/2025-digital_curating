import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

class NovelContentText extends StatelessWidget {
  final String text;
  const NovelContentText({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: MarkdownBlock(data: text),
    );
  }
}

class NovelContentImage extends StatelessWidget {
  final Map<String, dynamic> item;
  const NovelContentImage({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item["path"],
              fit: BoxFit.contain,
              width: double.infinity,
            ),
          ),
          if (item["caption"] != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                item["caption"],
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}

class NovelContentQuote extends StatelessWidget {
  final String text;
  const NovelContentQuote({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 4,
          ),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(fontStyle: FontStyle.italic)),
    );
  }
}

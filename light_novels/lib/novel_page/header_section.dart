import 'package:flutter/material.dart';

class NovelHeaderSection extends StatelessWidget {
  final Map<String, dynamic> novel;
  const NovelHeaderSection({super.key, required this.novel});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(novel["cover"], fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 32,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      novel["title"],
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                Text(
                  novel["author"],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 6,
                  children:
                      (novel["tags"] as List)
                          .map((tag) => Chip(label: Text(tag)))
                          .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

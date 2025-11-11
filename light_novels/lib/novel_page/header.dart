import 'package:flutter/material.dart';

class NovelHeader extends StatelessWidget {
  final String title;
  final String author;
  final String imagePath;

  const NovelHeader({
    required this.title,
    required this.author,
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 3 / 4, // 固定長寬比
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // 書名可水平滑動，但不超出寬度
        SizedBox(
          height: 32,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
        Text(
          author,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

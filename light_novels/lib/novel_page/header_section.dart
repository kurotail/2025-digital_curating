import 'package:flutter/material.dart';

class NovelHeaderSection extends StatelessWidget {
  const NovelHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset("assets/images/cover.jpg", fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 32,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  "路人女主的養成方法",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            Text("丸戸史明", style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

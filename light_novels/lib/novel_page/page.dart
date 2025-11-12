import 'package:flutter/material.dart';
import 'package:light_novels/novel_page/content_section.dart';
import 'package:light_novels/novel_page/header_section.dart';
import 'package:light_novels/novel_page/summary.dart';

class NovelPage extends StatelessWidget {
  final Map<String, dynamic> novel;
  const NovelPage({super.key, required this.novel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(novel["title"]),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.dark_mode)),
        ],
      ),
      body: ListView(
        children: [
          NovelHeaderSection(novel: novel),
          NovelSummary(text: novel["summary"], info: novel["info"]),
          NovelContentSection(content: novel["content"], links: novel["links"]),
        ],
      ),
    );
  }
}

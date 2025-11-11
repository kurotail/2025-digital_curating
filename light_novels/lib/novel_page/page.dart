import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
          NovelHeaderSection(novel: novel, info: novel["info"]),
          NovelContentSection(content: novel["content"], links: novel["links"]),
        ],
      ),
    );
  }
}

class NovelHeaderSection extends StatelessWidget {
  final Map<String, dynamic> info;
  final Map<String, dynamic> novel;
  const NovelHeaderSection({
    super.key,
    required this.novel,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
              Text(novel["author"], style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 6,
                children: (novel["tags"] as List)
                    .map((tag) => Chip(label: Text(tag)))
                    .toList(),
              ),
            ],
          ),
        ),
        Padding(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          runSpacing: 12,
          spacing: 24,
          children: info.entries
              .map((e) => _InfoItem(label: e.key, value: e.value.toString()))
              .toList(),
          ),
        ),
      ]
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label, value;
  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}

class NovelContentSection extends StatelessWidget {
  final List<dynamic> content;
  final List<dynamic> links;
  const NovelContentSection({
    super.key,
    required this.content,
    required this.links,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              content.map((item) {
                switch (item["type"]) {
                  case "text":
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        item["text"],
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  case "image":
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
                  case "quote":
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
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceVariant.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item["text"],
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    );
                  default:
                    return const SizedBox.shrink();
                }
              }).toList(),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              links.map((link) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () => launchUrl(Uri.parse(link["url"])),
                    child: Text(
                      link["label"],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}

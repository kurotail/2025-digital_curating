import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NovelLinkSection extends StatelessWidget {
  final Map<String, String> links; // e.g. {"購買連結": "https://..."}

  const NovelLinkSection({required this.links, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: links.entries.map((e) {
        return InkWell(
          onTap: () => launchUrl(Uri.parse(e.value)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              e.key,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:light_novels/novel_page/component.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            NovelContentText(text: "# 書評"),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  content.map((item) {
                    switch (item["type"]) {
                      case "text":
                        return NovelContentText(text: item["text"]);
                      case "image":
                        return NovelContentImage(item: item);
                      case "quote":
                        return NovelContentQuote(text: item["text"]);
                      default:
                        return const SizedBox.shrink();
                    }
                  }).toList(),
            ),
            NovelContentText(text: "# 連結"),
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
            SizedBox(
              width: 0,
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}

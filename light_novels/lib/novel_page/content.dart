import 'package:flutter/material.dart';
import 'package:light_novels/novel_page/component.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:light_novels/theme_config.dart';

class NovelContent extends StatelessWidget {
  final GlobalKey containerKey;
  final List<dynamic> content;
  final List<dynamic> links;
  final double? opacity;
  final NovelTheme theme;
  const NovelContent({
    super.key,
    required this.containerKey,
    required this.content,
    required this.links,
    this.opacity,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final double windowHeight = MediaQuery.of(context).size.height;
    return Container(
      key: containerKey,
      color: Colors.transparent,
      child: Opacity(
        opacity: opacity ?? 1.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: windowHeight * 1.1),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                NovelContentText(text: "# 書評", theme: theme),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      content.map((item) {
                        switch (item["type"]) {
                          case "text":
                            return NovelContentText(
                              text: item["text"],
                              theme: theme,
                            );
                          case "image":
                            return NovelContentImage(item: item, theme: theme);
                          case "quote":
                            return NovelContentQuote(
                              text: item["text"],
                              theme: theme,
                            );
                          default:
                            return const SizedBox.shrink();
                        }
                      }).toList(),
                ),
                NovelContentText(text: "# 連結", theme: theme),
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
                SizedBox(width: 0, height: windowHeight * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:light_novels/novel_page/component.dart';

class NovelSummary extends StatelessWidget {
  final GlobalKey containerKey;
  final String text;
  final Map<String, dynamic> info;
  final double? opacity;
  const NovelSummary({
    super.key,
    required this.containerKey,
    required this.text,
    required this.info,
    this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: containerKey,
      color: Colors.transparent,
      child: Opacity(
        opacity: opacity ?? 1.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 1.1,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NovelContentText(text: "# 簡介\n$text"),
                NovelContentText(text: "# 書本資訊"),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Wrap(
                    runSpacing: 12,
                    spacing: 24,
                    children:
                        info.entries
                            .map(
                              (e) => _InfoItem(
                                label: e.key,
                                value: e.value.toString(),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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

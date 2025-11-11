import 'package:flutter/material.dart';

class NovelBasicInfo extends StatelessWidget {
  final String publisher;
  final String releaseDate;
  final String isbn;
  final List<String> tags;

  const NovelBasicInfo({
    required this.publisher,
    required this.releaseDate,
    required this.isbn,
    required this.tags,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 8,
      spacing: 16,
      children: [
        _infoTile("出版社", publisher),
        _infoTile("發售日期", releaseDate),
        _infoTile("ISBN", isbn),
        _infoTile("標籤", tags.join(", ")),
      ],
    );
  }

  Widget _infoTile(String label, String value) {
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

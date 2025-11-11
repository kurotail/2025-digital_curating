import 'package:flutter/material.dart';

class NovelCharacterList extends StatelessWidget {
  final List<Map<String, String>> characters; // { "name": "", "desc": "", "image": "" }

  const NovelCharacterList({required this.characters, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("角色介紹", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...characters.map((ch) => _characterItem(context, ch)).toList(),
      ],
    );
  }

  Widget _characterItem(BuildContext context, Map<String, String> ch) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              ch["image"]!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ch["name"]!, style: Theme.of(context).textTheme.titleMedium),
                Text(ch["desc"]!, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          )
        ],
      ),
    );
  }
}

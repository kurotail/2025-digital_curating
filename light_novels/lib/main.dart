import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:light_novels/loading_animation.dart';
import 'package:light_novels/novel_page/page.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String name = "";
  bool loading = true;
  Map<String, dynamic> novelData = {};

  @override
  void initState() {
    super.initState();
    name = Uri.base.queryParameters['q'] ?? "default";
    loadJsonData(name);
  }

  void loadJsonData(String name) async {
    final String jsonString = await rootBundle.loadString(
      'assets/$name/context.json',
    );
    setState(() {
      novelData = jsonDecode(jsonString);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return LoadingAnimation();
    } else {
      return MaterialApp(
        title: novelData["title"],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: NovelPage(novel: novelData),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:light_novels/loading_animation.dart';
import 'package:light_novels/novel_page/page.dart';
import 'package:light_novels/home_page.dart';
import 'dart:convert';
import 'dart:html' as html;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '輕小說書評',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AppNavigator(),
    );
  }
}

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  String? novelName;
  bool loading = true;
  Map<String, dynamic>? novelData;

  @override
  void initState() {
    super.initState();
    _loadInitialRoute();
    
    // 監聽瀏覽器的返回/前進按鈕
    html.window.onPopState.listen((event) {
      _loadInitialRoute();
    });
  }

  void _loadInitialRoute() {
    final queryParam = Uri.base.queryParameters['q'];
    if (queryParam != null && queryParam.isNotEmpty) {
      _loadNovel(queryParam);
    } else {
      setState(() {
        novelName = null;
        novelData = null;
        loading = false;
      });
    }
  }

  Future<void> _loadNovel(String name) async {
    setState(() {
      loading = true;
      novelName = name;
    });

    try {
      print("loading $name");
      final String jsonString = await rootBundle.loadString(
        'assets/$name/context.json',
      );
      setState(() {
        novelData = jsonDecode(jsonString);
        loading = false;
      });
    } catch (e) {
      print("Error loading novel data: $e");
      setState(() {
        loading = false;
        novelName = null;
        novelData = null;
      });
    }
  }

  void navigateToNovel(String name) {
    // 更新 URL 但不重新載入頁面
    html.window.history.pushState(null, '', '?q=$name');
    _loadNovel(name);
  }

  void navigateToHome() {
    // 更新 URL 回到首頁
    html.window.history.pushState(null, '', '/');
    setState(() {
      novelName = null;
      novelData = null;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: LoadingAnimation(),
      );
    }

    // 如果有指定小說且成功載入，顯示小說頁面
    if (novelName != null && novelData != null) {
      return NovelPage(
        novel: novelData!,
        onBack: navigateToHome,
      ).animate().fadeIn(duration: 600.ms);
    }

    // 否則顯示首頁
    return HomePage(
      onNovelTap: navigateToNovel,
    ).animate().fadeIn(duration: 600.ms);
  }
}

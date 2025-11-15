import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:light_novels/loading_animation.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  final Function(String) onNovelTap;
  const HomePage({super.key, required this.onNovelTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> novels = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadNovels();
  }

  Future<void> _loadNovels() async {
    // 讀取小說列表配置文件
    try {
      final String configString = await rootBundle.loadString(
        'assets/novels_config.json',
      );
      final config = jsonDecode(configString);

      List<Map<String, dynamic>> loadedNovels = [];

      // 載入每本小說的基本信息
      for (String novelName in config['novels']) {
        try {
          final String jsonString = await rootBundle.loadString(
            'assets/$novelName/context.json',
          );
          final novelData = jsonDecode(jsonString);
          loadedNovels.add({
            'name': novelName,
            'title': novelData['title'],
            'cover': novelData['cover'],
            'author': novelData['author'],
            'tags': novelData['tags'],
          });
        } catch (e) {
          print('Error loading $novelName: $e');
        }
      }

      setState(() {
        novels = loadedNovels;
        loading = false;
      });
    } catch (e) {
      print('Error loading novels config: $e');
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(body: Center(child: LoadingAnimation()));
    }

    return novels.isEmpty
        ? Center(
          child: Text('暫無小說', style: Theme.of(context).textTheme.titleLarge),
        )
        : CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _getCrossAxisCount(context),
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  return NovelCard(
                        novel: novels[index],
                        onTap: () => widget.onNovelTap(novels[index]['name']),
                      )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: (index * 100).ms)
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        duration: 600.ms,
                        delay: (index * 100).ms,
                        curve: Curves.easeOutCubic,
                      );
                }, childCount: novels.length),
              ),
            ),
          ],
        );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 5;
    if (width > 900) return 4;
    if (width > 600) return 3;
    return 2;
  }
}

class NovelCard extends StatefulWidget {
  final Map<String, dynamic> novel;
  final VoidCallback onTap;

  const NovelCard({super.key, required this.novel, required this.onTap});

  @override
  State<NovelCard> createState() => _NovelCardState();
}

class _NovelCardState extends State<NovelCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Card(
            elevation: _isHovered ? 12 : 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.novel['cover'],
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return LoadingAnimation();
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.broken_image,
                              size: 48,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                      if (_isHovered)
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.7),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.novel['title'],
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.novel['author'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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

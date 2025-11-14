import 'package:flutter/material.dart';
import 'package:light_novels/loading_animation.dart';
import 'package:light_novels/theme_config.dart';

class NovelHeader extends StatelessWidget {
  final GlobalKey containerKey;
  final Map<String, dynamic> novel;
  final double? opacity;
  final NovelTheme theme;
  
  const NovelHeader({
    super.key,
    required this.containerKey,
    required this.novel,
    required this.theme,
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
          child: Column(
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
                        child: Image.network(
                          novel["cover"],
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return LoadingAnimation();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 32,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          novel["title"],
                          style: theme.getTitleStyle(),
                        ),
                      ),
                    ),
                    Text(
                      novel["author"],
                      style: theme.getSecondaryStyle(),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 6,
                      children: (novel["tags"] as List)
                          .map((tag) => Chip(
                                label: Text(
                                  tag,
                                  style: theme.getSmallStyle(),
                                ),
                                backgroundColor: theme.chipBg,
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

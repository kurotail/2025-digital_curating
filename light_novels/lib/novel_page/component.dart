import 'package:flutter/material.dart';
import 'package:light_novels/loading_animation.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:light_novels/theme_config.dart';

class NovelContentText extends StatefulWidget {
  final String text;
  final NovelTheme theme;
  const NovelContentText({super.key, required this.text, required this.theme});

  @override
  State<NovelContentText> createState() => _NovelContentTextState();
}

class _NovelContentTextState extends State<NovelContentText> {
  final GlobalKey _key = GlobalKey();
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _checkVisibility() {
    if (!mounted) return;

    final RenderBox? renderBox =
        _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    setState(() {
      _isVisible = position.dy < screenHeight * 0.9;
    });
  }

  @override
  Widget build(BuildContext context) {
    _checkVisibility();
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 600),
      opacity: _isVisible ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
        offset: _isVisible ? Offset.zero : const Offset(-0.1, 0),
        child: Padding(
          key: _key,
          padding: const EdgeInsets.only(bottom: 16),
          child: MarkdownBlock(
            data: widget.text,
            config: widget.theme.getMarkdownStyle()
          ),
        ),
      ),
    );
  }
}

class NovelContentImage extends StatefulWidget {
  final Map<String, dynamic> item;
  final NovelTheme theme;
  const NovelContentImage({super.key, required this.item, required this.theme});

  @override
  State<NovelContentImage> createState() => _NovelContentImageState();
}

class _NovelContentImageState extends State<NovelContentImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _elevationAnimation = Tween<double>(
      begin: 0.5,
      end: 15.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _elevationAnimation,
            builder: (context, child) {
              return PhysicalModel(
                elevation: _elevationAnimation.value,
                color: Colors.white,
                shadowColor: Colors.black,
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.antiAlias,
                child: child!,
              );
            },
            child: Image.network(
              widget.item["path"],
              fit: BoxFit.contain,
              width: double.infinity,
              filterQuality: FilterQuality.high,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return LoadingAnimation();
              },
            ),
          ),
          if (widget.item["caption"] != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                widget.item["caption"],
                style: widget.theme.getCaptionStyle(),
              ),
            ),
        ],
      ),
    );
  }
}

class NovelContentQuote extends StatelessWidget {
  final String text;
  final NovelTheme theme;
  const NovelContentQuote({super.key, required this.text, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 4,
          ),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: theme.getQuoteStyle()),
    );
  }
}

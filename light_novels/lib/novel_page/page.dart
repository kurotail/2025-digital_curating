import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:light_novels/novel_page/content.dart';
import 'package:light_novels/novel_page/header.dart';
import 'package:light_novels/novel_page/scroll_indicator.dart';
import 'package:light_novels/novel_page/summary.dart';
import 'package:light_novels/theme_config.dart';
import 'dart:math';

class NovelPage extends StatefulWidget {
  final Map<String, dynamic> novel;
  final VoidCallback onBack;

  const NovelPage({super.key, required this.novel, required this.onBack});

  @override
  State<NovelPage> createState() => _NovelPageState();
}

class _NovelPageState extends State<NovelPage> {
  double _scrollOffset = 0.0;

  double _headerHeight = 0.0;
  double _summaryHeight = 0.0;
  double _contentHeight = 0.0;

  final GlobalKey _headerKey = GlobalKey();
  final GlobalKey _summaryKey = GlobalKey();
  final GlobalKey _contentKey = GlobalKey();

  double _windowHeight = 0.0;

  // 使用 NovelTheme 管理主題
  late NovelTheme _theme;

  @override
  void initState() {
    super.initState();
    _theme = NovelTheme.light(); // 預設為淺色主題

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _windowHeight = MediaQuery.of(context).size.height;
      _measureHeights();
    });
  }

  void _toggleTheme() {
    setState(() {
      _theme = _theme.isDark ? NovelTheme.light() : NovelTheme.dark();
    });
  }

  void _measureHeights() {
    final headerBox =
        _headerKey.currentContext?.findRenderObject() as RenderBox?;
    final summaryBox =
        _summaryKey.currentContext?.findRenderObject() as RenderBox?;
    final contentBox =
        _contentKey.currentContext?.findRenderObject() as RenderBox?;

    if (headerBox != null && summaryBox != null && contentBox != null) {
      setState(() {
        _headerHeight = headerBox.size.height;
        _summaryHeight = summaryBox.size.height;
        _contentHeight = contentBox.size.height;
      });
    }
  }

  void _remeasureIfNeeded() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contentBox =
          _contentKey.currentContext?.findRenderObject() as RenderBox?;
      if (contentBox != null && contentBox.size.height != _contentHeight) {
        _measureHeights();
      }
    });
  }

  void _updateScrollOffset(double offset) {
    setState(() {
      _scrollOffset = offset;
    });
  }

  double _getHeaderTop() {
    return -min(
      _scrollOffset,
      (_scrollOffset + _headerHeight - _windowHeight) / 3.0,
    );
  }

  double _getHeaderOpacity() {
    return (_getSummaryTop() * 2.5 / _windowHeight).clamp(0.0, 1.0);
  }

  double _getSummaryTop() {
    final totalPreviousHeight = _headerHeight;
    return -min(
      _scrollOffset - totalPreviousHeight,
      (_scrollOffset - totalPreviousHeight + _summaryHeight - _windowHeight) /
          3.0,
    );
  }

  double _getSummaryOpacity() {
    if ((_windowHeight - _getContentTop() > 0.1)) {
      return (_getContentTop() * 1.5 / _windowHeight).clamp(0.0, 1.0);
    } else {
      return ((_windowHeight - _getSummaryTop() * 2.5) / _windowHeight).clamp(
        0.0,
        1.0,
      );
    }
  }

  double _getContentTop() {
    final totalPreviousHeight = _headerHeight + _summaryHeight;
    return totalPreviousHeight - _scrollOffset.clamp(0.0, double.infinity);
  }

  double _getContentOpacity() {
    return ((_windowHeight - _getContentTop() * 1.5) / _windowHeight).clamp(
      0.0,
      1.0,
    );
  }

  double _getTotalScrollHeight() {
    return _headerHeight + _summaryHeight + _contentHeight - _windowHeight;
  }

  Color _getBackgroundColor() {
    if (_scrollOffset <= _summaryHeight) {
      final t = _scrollOffset / _summaryHeight;
      return Color.lerp(_theme.headerBg, _theme.summaryBg, t) ??
          _theme.headerBg;
    } else {
      final contentScroll = _scrollOffset - _summaryHeight;
      final contentScrollableLength = _contentHeight;
      final t = min(1.0, contentScroll / contentScrollableLength);
      return Color.lerp(_theme.summaryBg, _theme.contentBg, t) ??
          _theme.summaryBg;
    }
  }

  bool _showIndicator() {
    return _getTotalScrollHeight() - _scrollOffset > _windowHeight * 0.5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: Text(widget.novel["title"]),
        backgroundColor: _theme.headerBg,
        foregroundColor: _theme.primaryText,
        actions: [
          IconButton(
            onPressed: _toggleTheme,
            icon:
                _theme.isDark
                    ? const Icon(Icons.light_mode)
                    : const Icon(Icons.dark_mode),
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: _getBackgroundColor(),
        child: Listener(
          onPointerSignal: (pointerSignal) {
            if (pointerSignal is PointerScrollEvent) {
              _updateScrollOffset(
                (_scrollOffset + pointerSignal.scrollDelta.dy * 2.0).clamp(
                  0.0,
                  _getTotalScrollHeight(),
                ),
              );
            }
          },
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              _updateScrollOffset(
                (_scrollOffset - details.delta.dy * 2.0).clamp(
                  0.0,
                  _getTotalScrollHeight(),
                ),
              );
            },
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 100),
                  top: _getHeaderTop(),
                  left: 0,
                  right: 0,
                  child: NovelHeader(
                    containerKey: _headerKey,
                    opacity: _getHeaderOpacity(),
                    novel: widget.novel,
                    theme: _theme,
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 100),
                  top: _getSummaryTop(),
                  left: 0,
                  right: 0,
                  child: NovelSummary(
                    containerKey: _summaryKey,
                    opacity: _getSummaryOpacity(),
                    text: widget.novel["summary"],
                    info: widget.novel["info"],
                    theme: _theme,
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 100),
                  top: _getContentTop(),
                  left: 0,
                  right: 0,
                  child: NotificationListener<SizeChangedLayoutNotification>(
                    onNotification: (notification) {
                      _remeasureIfNeeded();
                      return true;
                    },
                    child: SizeChangedLayoutNotifier(
                      child: NovelContent(
                        containerKey: _contentKey,
                        opacity: _getContentOpacity(),
                        content: widget.novel["content"],
                        links: widget.novel["links"],
                        theme: _theme,
                      ),
                    ),
                  ),
                ),
                _showIndicator() ? ScrollIndicator() : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

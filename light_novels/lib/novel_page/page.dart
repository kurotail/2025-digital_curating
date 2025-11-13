import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:light_novels/novel_page/content.dart';
import 'package:light_novels/novel_page/header.dart';
import 'package:light_novels/novel_page/scroll_indicator.dart';
import 'package:light_novels/novel_page/summary.dart';
import 'dart:math';

class NovelPage extends StatefulWidget {
  final Map<String, dynamic> novel;
  const NovelPage({super.key, required this.novel});

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

  // 定義每個區塊的背景顏色
  Color headerColor = Colors.blue.shade50;
  Color summaryColor = Colors.green.shade50;
  Color contentColor = Colors.orange.shade50;

  double _windowHeight = 0.0;
  // double _windowWidth = 0.0;

  bool _nightColor = false;

  @override
  void initState() {
    super.initState();
    // 在下一幀測量高度
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _windowHeight = MediaQuery.of(context).size.height;
      // _windowWidth = MediaQuery.of(context).size.width;
      _measureHeights();
    });
  }

  void _toggleColors() {
    _nightColor = !_nightColor;
    setState(() {
      headerColor =
          _nightColor ? Colors.blueGrey.shade900 : Colors.blue.shade50;
      summaryColor = _nightColor ? Colors.teal.shade900 : Colors.green.shade50;
      contentColor =
          _nightColor ? Colors.brown.shade900 : Colors.orange.shade50;
    });
  }

  // 測量所有子元件的高度
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

  // 當內容變化時重新測量
  void _remeasureIfNeeded() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contentBox =
          _contentKey.currentContext?.findRenderObject() as RenderBox?;
      if (contentBox != null && contentBox.size.height != _contentHeight) {
        _measureHeights();
      }
    });
  }

  // 更新共用的滾動偏移量
  void _updateScrollOffset(double offset) {
    setState(() {
      _scrollOffset = offset;
    });
  }

  // 計算 Header 的位置
  double _getHeaderTop() {
    return -min(
      _scrollOffset,
      (_scrollOffset + _headerHeight - _windowHeight) / 3.0,
    );
  }

  double _getHeaderOpacity() {
    return (_getSummaryTop() * 2.5 / _windowHeight).clamp(0.0, 1.0);
  }

  // 計算 Summary 的位置
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

  // 計算 Content 的位置
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

  // 計算總的可滾動高度
  double _getTotalScrollHeight() {
    return _headerHeight + _summaryHeight + _contentHeight - _windowHeight;
  }

  Color _getBackgroundColor() {
    if (_scrollOffset <= _summaryHeight) {
      final t = _scrollOffset / _summaryHeight;
      return Color.lerp(headerColor, summaryColor, t) ?? headerColor;
    } else {
      final contentScroll = _scrollOffset - _summaryHeight;
      final contentScrollableLength = _contentHeight;
      final t = min(1.0, contentScroll / contentScrollableLength);
      return Color.lerp(summaryColor, contentColor, t) ?? summaryColor;
    }
  }

  bool _showIndicator() {
    return _getTotalScrollHeight() - _scrollOffset > _windowHeight * 0.5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.novel["title"]),
        actions: [
          IconButton(
            onPressed: () {
              _toggleColors();
            },
            icon: _nightColor ? Icon(Icons.light_mode) : Icon(Icons.dark_mode),
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: _getBackgroundColor(), // 應用漸變顏色
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
                // Header Section (最底層) - 可滾動
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 100),
                  top: _getHeaderTop(),
                  left: 0,
                  right: 0,
                  child: NovelHeader(
                    containerKey: _headerKey,
                    opacity: _getHeaderOpacity(),
                    novel: widget.novel,
                  ),
                ),

                // Summary Section (中間層) - 可滾動
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
                  ),
                ),

                // Content Section (最上層) - 可滾動
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

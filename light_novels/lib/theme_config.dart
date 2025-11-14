import 'package:flutter/material.dart';
import 'package:markdown_widget/config/all.dart';
import 'package:markdown_widget/widget/all.dart';

class NovelTheme {
  final bool isDark;

  // Background colors
  final Color headerBg;
  final Color summaryBg;
  final Color contentBg;

  // Text colors
  final Color primaryText;
  final Color secondaryText;
  final Color linkColor;

  // Component colors
  final Color quoteBorder;
  final Color chipBg;
  final Color shadowColor;

  // Font sizes
  final double titleSize;
  final double bodySize;
  final double smallSize;
  final double captionSize;

  NovelTheme({
    required this.isDark,
    required this.headerBg,
    required this.summaryBg,
    required this.contentBg,
    required this.primaryText,
    required this.secondaryText,
    required this.linkColor,
    required this.quoteBorder,
    required this.chipBg,
    required this.shadowColor,
    this.titleSize = 24.0,
    this.bodySize = 16.0,
    this.smallSize = 14.0,
    this.captionSize = 12.0,
  });

  // Light theme
  factory NovelTheme.light() {
    return NovelTheme(
      isDark: false,
      headerBg: Colors.blue.shade50,
      summaryBg: Colors.green.shade50,
      contentBg: Colors.orange.shade50,
      primaryText: Colors.black87,
      secondaryText: Colors.black54,
      linkColor: Colors.blue.shade700,
      quoteBorder: Colors.blue.shade700,
      chipBg: Colors.grey.shade200,
      shadowColor: Colors.black26,
    );
  }

  // Dark theme
  factory NovelTheme.dark() {
    return NovelTheme(
      isDark: true,
      headerBg: Colors.blueGrey.shade900,
      summaryBg: Colors.black87,
      contentBg: Colors.blueGrey.shade800,
      primaryText: Colors.white70,
      secondaryText: Colors.white60,
      linkColor: Colors.lightBlue.shade300,
      quoteBorder: Colors.lightBlue.shade300,
      chipBg: Colors.grey.shade800,
      shadowColor: Colors.black87,
    );
  }

  // Get text style with theme colors
  TextStyle getTitleStyle() {
    return TextStyle(
      fontSize: titleSize,
      fontWeight: FontWeight.bold,
      color: primaryText,
    );
  }

  TextStyle getBodyStyle() {
    return TextStyle(fontSize: bodySize, color: primaryText);
  }

  TextStyle getSecondaryStyle() {
    return TextStyle(fontSize: bodySize, color: secondaryText);
  }

  TextStyle getSmallStyle() {
    return TextStyle(fontSize: smallSize, color: secondaryText);
  }

  TextStyle getCaptionStyle() {
    return TextStyle(fontSize: captionSize, color: secondaryText);
  }

  TextStyle getLinkStyle() {
    return TextStyle(
      fontSize: bodySize,
      color: linkColor,
      decoration: TextDecoration.underline,
    );
  }

  TextStyle getQuoteStyle() {
    return TextStyle(
      fontSize: bodySize,
      fontStyle: FontStyle.italic,
      color: primaryText,
    );
  }

  MarkdownConfig getMarkdownStyle() {
    return isDark
        ? MarkdownConfig.darkConfig.copy(
          configs: [PConfig(textStyle: getBodyStyle()), PreConfig(textStyle: getBodyStyle())],
        )
        : MarkdownConfig.defaultConfig;
  }
}

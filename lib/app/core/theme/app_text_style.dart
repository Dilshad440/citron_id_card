import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyle {
  AppTextStyle._();

  static _toStyle({
    required double fontSize,
    required FontWeight fontWeight,
    double? height,
    double? letterSpacing,
    Color? color,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static final display = _MyTextStyleSet(
    large: _toStyle(fontSize: 26, fontWeight: FontWeight.w700),
    medium: _toStyle(fontSize: 22, fontWeight: FontWeight.w500),
    small: _toStyle(fontSize: 20, fontWeight: FontWeight.w400),
  );
  static final title = _MyTextStyleSet(
    large: _toStyle(fontSize: 20, fontWeight: FontWeight.w700),
    medium: _toStyle(fontSize: 18, fontWeight: FontWeight.w500),
    small: _toStyle(fontSize: 16, fontWeight: FontWeight.w400),
  );

  static final body = _MyTextStyleSet(
    large: _toStyle(fontSize: 18, fontWeight: FontWeight.w600),
    medium: _toStyle(fontSize: 16, fontWeight: FontWeight.w400),
    small: _toStyle(fontSize: 14, fontWeight: FontWeight.w300),
  );
}

///  Providing TextStyle to MyTextStyle Sets
class _MyTextStyleSet extends _MyTextStyle {
  final _MyTextStyle large;
  final _MyTextStyle small;
  final _MyTextStyle medium;

  _MyTextStyleSet({
    required TextStyle large,
    required TextStyle medium,
    required TextStyle small,
  })  : large = _MyTextStyle(large),
        small = _MyTextStyle(small),
        medium = _MyTextStyle(medium),
        super(medium);
}

/// App TextStyle ---------

class _MyTextStyle extends TextStyle {
  _MyTextStyle(TextStyle style)
      : super(
          color: style.color,
          backgroundColor: style.backgroundColor,
          fontSize: style.fontSize,
          fontWeight: style.fontWeight,
          fontStyle: style.fontStyle,
          letterSpacing: style.letterSpacing,
          wordSpacing: style.wordSpacing,
          textBaseline: style.textBaseline,
          height: style.height,
          leadingDistribution: style.leadingDistribution,
          locale: style.locale,
          foreground: style.foreground,
          background: style.background,
          shadows: style.shadows,
          fontFeatures: style.fontFeatures,
          decoration: style.decoration,
          decorationColor: style.decorationColor,
          decorationStyle: style.decorationStyle,
          decorationThickness: style.decorationThickness,
          debugLabel: style.debugLabel,
          overflow: style.overflow,
        );

  _MyTextStyle get red => _MyTextStyle(copyWith(color: AppColors.red));

  _MyTextStyle get black => _MyTextStyle(copyWith(color: AppColors.black));

  _MyTextStyle get grey => _MyTextStyle(copyWith(color: AppColors.grey));
  _MyTextStyle get teal => _MyTextStyle(copyWith(color: AppColors.teal));

  _MyTextStyle get white => _MyTextStyle(copyWith(color: AppColors.white));

  _MyTextStyle get extraBold => _MyTextStyle(copyWith(fontWeight: FontWeight.w800));

  _MyTextStyle get regular => _MyTextStyle(copyWith(fontWeight: FontWeight.w400));

  _MyTextStyle get medium => _MyTextStyle(copyWith(fontWeight: FontWeight.w500));

  _MyTextStyle get semiBold => _MyTextStyle(copyWith(fontWeight: FontWeight.w600));

  _MyTextStyle get bold => _MyTextStyle(copyWith(fontWeight: FontWeight.w700));

  _MyTextStyle get lightWeight => _MyTextStyle(copyWith(fontWeight: FontWeight.w300));

  _MyTextStyle get blackHeavy => _MyTextStyle(copyWith(fontWeight: FontWeight.w900));

  _MyTextStyle get italic => _MyTextStyle(copyWith(fontStyle: FontStyle.italic));

  _MyTextStyle get ellipsis => _MyTextStyle(copyWith(overflow: TextOverflow.ellipsis));

  Text text(
    String text, {
    InlineSpan? textSpan,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    ui.TextHeightBehavior? textHeightBehavior,
    Paint? foreground,
    Paint? background,
    List<ui.Shadow>? shadows,
// List<ui.FontFeature>? fontFeatures,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? debugLabel,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,
  }) {
    return Text(
      text,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      style: copyWith(
          inherit: inherit,
          color: color,
          backgroundColor: backgroundColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
          textBaseline: textBaseline,
          height: height,
          leadingDistribution: leadingDistribution,
          locale: locale,
          foreground: foreground,
          background: background,
          shadows: shadows,
          fontFeatures: fontFeatures,
          decoration: decoration,
          decorationColor: decorationColor,
          decorationStyle: decorationStyle,
          debugLabel: debugLabel,
          decorationThickness: decorationThickness,
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontStyle: fontStyle,
          fontVariations: fontVariations,
          overflow: overflow,
          package: package),
    );
  }
}

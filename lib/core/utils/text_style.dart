import 'package:flutter/material.dart';
import 'package:bookstore_app/core/utils/app_colors.dart';

TextStyle getTitleStyle(
    {Color? color, double? fontSize, FontWeight? fontWeight}) {
  return TextStyle(
      color: color ?? AppColors.black,
      fontSize: fontSize ?? 22,
      fontWeight: fontWeight ?? FontWeight.bold);
}

TextStyle getBodyStyle(
    {Color? color, double? fontSize, FontWeight? fontWeight}) {
  return TextStyle(
      color: color ?? AppColors.black,
      fontSize: fontSize ?? 16,
      fontWeight: fontWeight ?? FontWeight.w500);
}

TextStyle getSmallStyle(
    {Color? color, double? fontSize, FontWeight? fontWeight}) {
  return TextStyle(
      color: color ?? AppColors.white,
      fontSize: fontSize ?? 12,
      fontWeight: fontWeight ?? FontWeight.w300);
}

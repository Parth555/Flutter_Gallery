import '../../../utils/app_color.dart';
import '../../../utils/constant.dart';
import '../../../utils/sizer_utils.dart';
import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  final String text;
  final Color textColor;
  final double? fontSize;
  final String fontFamily;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final TextAlign textAlign;
  final TextDecoration textDecoration;
  final int? maxLines;

  const CommonText({
    super.key,
    required this.text,
    this.fontSize,
    this.maxLines,
    this.textColor = AppColor.primary,
    this.fontFamily = Constant.fontFamilyInter,
    this.fontWeight = FontWeight.w400,
    this.fontStyle = FontStyle.normal,
    this.textAlign = TextAlign.center,
    this.textDecoration = TextDecoration.none,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontSize: fontSize ?? AppSizes.setFontSize(14),
        color: textColor,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        decoration: textDecoration,
      ),
    );
  }
}

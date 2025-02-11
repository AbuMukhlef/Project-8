import 'package:flutter/material.dart';

extension CustomTextStyle on Text {
  Text styled({
    double size = 14,
    Color color = Colors.black,
    FontWeight weight = FontWeight.w400,
    TextAlign align = TextAlign.start,
    int lineLimit = 30,
    bool cross = false,
    
  }) {
    return Text(
      data!,
      textAlign: align,
      softWrap: true,
      maxLines: lineLimit,
      style: TextStyle(
        fontSize: size,
        fontFamily: 'Poppins',
        color: color,
        fontWeight: weight,
        decoration: cross ? TextDecoration.lineThrough : TextDecoration.none,
      ),
    );
  }
}

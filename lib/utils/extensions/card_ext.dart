import 'package:flutter/material.dart';

class TaiCard extends Card {
  const TaiCard({
    required super.child,
    super.key,
    super.color,
    super.shape,
    super.margin,
    double? elevation,
    Clip? clipBehavior,
    Color? shadowColor,
  }) : super(
          elevation: elevation ?? 6.0,
          shadowColor: shadowColor ?? Colors.black38,
          clipBehavior: clipBehavior ?? Clip.hardEdge,
        );

  /// The TaiCard.margin constructor creates a card with a default margin.
  const TaiCard.margin({
    super.key,
    required super.child,
    super.color,
    super.shape,
    double? elevation,
    Clip? clipBehavior,
    EdgeInsetsGeometry? margin,
    Color? shadowColor,
  }) : super(
          elevation: elevation ?? 6.0,
          shadowColor: shadowColor ?? Colors.black38,
          clipBehavior: clipBehavior ?? Clip.hardEdge,
          margin: margin ?? const EdgeInsets.all(8),
        );
}

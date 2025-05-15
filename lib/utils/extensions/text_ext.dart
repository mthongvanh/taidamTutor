import 'package:flutter/material.dart';

extension TaiText on Text {
  static Text appBarTitle(String text, BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

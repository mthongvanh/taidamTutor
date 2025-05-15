import 'package:flutter/material.dart';
import 'package:taidam_tutor/utils/extensions/card_ext.dart';

class TaiError extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const TaiError(
    this.errorMessage, {
    this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          children: [
            Text(
              'Oops, something went wrong!',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            TaiCard(
              shadowColor: Colors.black,
              elevation: 12,
              child: Image.asset(
                'assets/images/png/sad-construction.png',
                // width: 200,
                // height: 200,
              ),
            ),
            const SizedBox(height: 16),
            if (onRetry != null)
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Try Again / Reset'),
              )
          ],
        ),
      ),
    );
  }
}

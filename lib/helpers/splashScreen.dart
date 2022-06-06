import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('yt');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ScalingText(
              'Loading...',
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 32.0),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

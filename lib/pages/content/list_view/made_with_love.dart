import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MadeWithLoveLabel extends StatelessWidget {
  const MadeWithLoveLabel({Key? key}) : super(key: key);

  final url = "https://github.com/u5ele55";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(fontSize: 20),
          children: [
            const TextSpan(
              text: "Made with pure ❤️ by ",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: "u5ele55",
              style: const TextStyle(
                color: Colors.amber,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async => await launchUrl(Uri.parse(url),
                    mode: LaunchMode.externalApplication),
            ),
          ],
        ),
      ),
    );
  }
}

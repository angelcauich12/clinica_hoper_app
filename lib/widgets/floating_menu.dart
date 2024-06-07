import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FloatingMenu extends StatelessWidget {
  const FloatingMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final Uri url = Uri(scheme: 'tel', path: '999108969');
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          print('cannot launch this url');
        }
      },
      child: const Icon(
        Icons.phone_enabled_outlined,
        size: 25,
      ),
    );
  }
}

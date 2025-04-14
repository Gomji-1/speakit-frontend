import 'package:flutter/material.dart';
import 'about_page.dart';
// import 'support_page.dart';
import 'privacy_policy_page.dart';
import 'contact_page.dart';
import 'ocr_tts_support_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: const Color(0xffF0F2F5),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Learn More',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.article, color: Colors.black),
                  title: const Text(
                    'About',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language, color: Colors.black),
                  title: const Text(
                    'Voice & Language Info',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OcrTtsSupportPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip, color: Colors.black),
                  title: const Text(
                    'Privacy Policy',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.black),
                  title: const Text(
                    'Contact/Feedback',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ContactPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

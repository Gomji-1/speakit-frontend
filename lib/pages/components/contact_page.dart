import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart'; // For Clipboard

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F2F5),
      appBar: AppBar(
        title: const Text(
          'Contact / Feedback',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'We\'d love to hear from you! Reach out to us via email or submit your feedback below.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Email Information (Clickable)
            GestureDetector(
              onTap: () async {
                const email =
                    'mailto:gomji.feedback@gmail.com'; // Simple mailto link
                if (await canLaunchUrl(Uri.parse(email))) {
                  await launchUrl(Uri.parse(email),
                      mode: LaunchMode.externalApplication);
                } else {
                  // Fallback: Copy email to clipboard
                  await Clipboard.setData(
                      const ClipboardData(text: 'gomji.feedback@gmail.com'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Email address copied to clipboard. Please paste it into your email app.'),
                    ),
                  );
                }
              },
              child: const Text(
                'gomji.feedback@gmail.com',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue, // Make it look like a link
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8), // Reduced spacing for better flow

            // Friendly prompt to fill the form
            const Text(
              'Alternatively, fill out the form below:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Feedback Button (Google Form)
            ElevatedButton(
              onPressed: () async {
                const url =
                    'https://docs.google.com/forms/d/e/1FAIpQLScy9ftZPUoPhI1xczBxbuRaRHdH7_cLA0zi8m1s0yUs2j3ioA/viewform?usp=header';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url),
                      mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Could not launch the form. Please check your internet connection and try again.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}

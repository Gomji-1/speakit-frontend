import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // For SVG support
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F2F5),
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // App Logo
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/icons/app_icon.png', // Path to your logo
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // App Name
            const Text(
              'SpeakIt',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            // Tagline
            const Text(
              'Don\'t Wanna Read It? No Worries, Just SPEAKIT!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // App Description
            const Text(
              'SpeakIt is a mobile application designed to convert images containing text into MP3 audio files using OCR (Optical Character Recognition) and TTS (Text-to-Speech) technology. It\'s perfect for students, professionals, and anyone who prefers audio content.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Key Features
            const Text(
              'Key Features',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white, // White background for the container
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildFeatureItem(
                      icon: Icons.image,
                      title: 'Image-to-Text Conversion',
                      description:
                          'Extract text from images using advanced OCR technology.',
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      icon: Icons.volume_up,
                      title: 'Text-to-Speech Conversion',
                      description:
                          'Convert extracted text into high-quality MP3 audio files.',
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      icon: Icons.download,
                      title: 'MP3 Download',
                      description:
                          'Download audio files for offline listening.',
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      icon: Icons.design_services,
                      title: 'Minimalist Design',
                      description:
                          'Simple and intuitive user interface for seamless navigation.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Developer Info
            const Text(
              'Developed by Sahajpreet Singh',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Social Media Links (SVG Icons)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LinkedIn Icon
                GestureDetector(
                  onTap: () async {
                    const url =
                        'https://www.linkedin.com/in/sahajpreet-singh-93b027278';
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                  child: SvgPicture.asset(
                    'assets/icons/linkedin.svg', // Path to LinkedIn SVG
                    width: 28, // Increased size
                    height: 28, // Increased size
                  ),
                ),
                const SizedBox(width: 20),

                // Instagram Icon
                GestureDetector(
                  onTap: () async {
                    const url =
                        'https://www.instagram.com/gxmji?igsh=MTB4YWZha2dmaW1nbw==';
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                  child: SvgPicture.asset(
                    'assets/icons/instagram.svg', // Path to Instagram SVG
                    width: 28, // Increased size
                    height: 28, // Increased size
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Support Email
            const Text(
              'For support or feedback, contact: gomji.feedback@gmail.com',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Version
            const Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a feature item
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 24, // Slightly smaller icon
          color: Colors.blue, // Use a theme color or any color you prefer
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14, // Smaller font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12, // Smaller font size
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

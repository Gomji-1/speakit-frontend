import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F2F5),
      appBar: AppBar(
        title: const _AppBarTitle(),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: _InfoContent(),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'How to Use',
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _InfoContent extends StatelessWidget {
  const _InfoContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AppOverviewSection(),
        SizedBox(height: 20),
        _HowToUseSection(),
        SizedBox(height: 20),
        _SupportedLanguagesSection(),
        SizedBox(height: 20),
        _TipsSection(),
      ],
    );
  }
}

class _AppOverviewSection extends StatelessWidget {
  const _AppOverviewSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to the App!',
          style: _headerTextStyle,
        ),
        SizedBox(height: 8),
        Text(
          'This app helps you extract text from images and convert it into speech. '
          'It\'s simple, fast, and supports multiple languages.',
          style: _bodyTextStyle,
        ),
      ],
    );
  }
}

class _HowToUseSection extends StatelessWidget {
  const _HowToUseSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How to Use',
          style: _headerTextStyle,
        ),
        SizedBox(height: 8),
        _StepItem(
          icon: Icons.camera_alt,
          title: 'Capture or Select an Image',
          description:
              'Use the camera to take a photo or choose an image from your gallery.',
        ),
        _StepItem(
          icon: Icons.text_snippet,
          title: 'Extract Text',
          description:
              'The app will automatically extract text from the image. '
              'Make sure the text is clear and well-lit.',
        ),
        _StepItem(
          icon: Icons.volume_up,
          title: 'Listen to the Text',
          description:
              'Convert the extracted text into speech and listen to it '
              'in your preferred language.',
        ),
      ],
    );
  }
}

class _SupportedLanguagesSection extends StatelessWidget {
  const _SupportedLanguagesSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Supported Languages',
          style: _headerTextStyle,
        ),
        SizedBox(height: 8),
        Text(
          'The app supports the following languages:',
          style: _bodyTextStyle,
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            LanguageChip('English'),
            LanguageChip('German'),
            LanguageChip('Hindi'),
            LanguageChip('Japanese'),
            LanguageChip('Spanish'),
          ],
        ),
      ],
    );
  }
}

class _TipsSection extends StatelessWidget {
  const _TipsSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tips for Best Results',
          style: _headerTextStyle,
        ),
        SizedBox(height: 8),
        _TipItem(
          icon: Icons.lightbulb_outline,
          tip: 'Use good lighting when capturing images.',
        ),
        _TipItem(
          icon: Icons.text_fields,
          tip: 'Ensure the text is aligned properly and not skewed.',
        ),
        _TipItem(
          icon: Icons.zoom_in,
          tip: 'Zoom in on the text for better accuracy.',
        ),
        _TipItem(
          icon: Icons.warning,
          tip: 'Handwritten text may not be as accurate as printed text.',
        ),
      ],
    );
  }
}

class _StepItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _StepItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: _subHeaderTextStyle,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: _bodyTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final IconData icon;
  final String tip;

  const _TipItem({
    required this.icon,
    required this.tip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: _bodyTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageChip extends StatelessWidget {
  final String language;

  const LanguageChip(this.language, {super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        language,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: const Color(0xffEDEDED),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

// Text styles as constants for better maintainability
const _headerTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const _subHeaderTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const _bodyTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.black54,
);

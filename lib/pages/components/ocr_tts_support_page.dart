import 'package:flutter/material.dart';

class OcrTtsSupportPage extends StatelessWidget {
  const OcrTtsSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F2F5),
      appBar: AppBar(
        title: const Text(
          'Voice & Language Info',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // OCR & TTS Support Title
            const Text(
              'OCR & TTS Language Support',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This guide explains how OCR (Text Recognition) and TTS (Text-to-Speech) function with different languages and voice types.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),

            // Tesseract OCR Supported Languages
            const Text(
              'Tesseract OCR Supported Languages',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'The following languages are supported for text recognition (OCR):\n'
              'English (eng), German (deu), Hindi (hin), Japanese (jpn), Spanish (spa).',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),

            // TTS (Text-to-Speech) Voice Support
            const Text(
              'TTS (Text-to-Speech) Voice Support',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Each language has dedicated male and female voices for natural speech output.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),

            // Minimalist List for TTS Voice Support
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildVoiceSupportItem(
                      language: 'English',
                      maleVoice: 'Christopher',
                      femaleVoice: 'Aria',
                      scripts: 'Latin ✅',
                    ),
                    _buildVoiceSupportItem(
                      language: 'Hindi',
                      maleVoice: 'Madhur',
                      femaleVoice: 'Swara',
                      scripts: 'Latin ✅, Devanagari ✅',
                    ),
                    _buildVoiceSupportItem(
                      language: 'German',
                      maleVoice: 'Conrad',
                      femaleVoice: 'Katja',
                      scripts: 'Latin ✅',
                    ),
                    _buildVoiceSupportItem(
                      language: 'Japanese',
                      maleVoice: 'Keita',
                      femaleVoice: 'Nanami',
                      scripts: 'Latin ✅, Kanji/Hiragana ✅',
                    ),
                    _buildVoiceSupportItem(
                      language: 'Spanish',
                      maleVoice: 'Alvaro',
                      femaleVoice: 'Elvira',
                      scripts: 'Latin ✅',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Key Insights
            const Text(
              'Key Insights',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildKeyInsight(
                    '✅ Latin (English text) is universally supported across all voices.'),
                _buildKeyInsight(
                    "✅ Each language's native script is supported only by its respective voice."),
                _buildKeyInsight(
                    '❌ All other scripts are ignored or mispronounced.'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceSupportItem({
    required String language,
    required String maleVoice,
    required String femaleVoice,
    required String scripts,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            language,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Male: $maleVoice | Female: $femaleVoice',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Supports: $scripts',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const Divider(height: 20, thickness: 1),
        ],
      ),
    );
  }

  Widget _buildKeyInsight(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

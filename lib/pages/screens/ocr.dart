import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'tts.dart';
import 'dart:async'; // This provides TimeoutException

class OcrPage extends StatefulWidget {
  final String imagePath;

  const OcrPage({super.key, required this.imagePath});

  @override
  State<OcrPage> createState() => _OcrPageState();
}

class _OcrPageState extends State<OcrPage> {
  final TextEditingController _textController = TextEditingController();
  String _selectedLanguage = 'English';
  String _selectedVoice = 'Male';
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendImageToServer();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _sendImageToServer() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://54.179.204.181:5000/ocr'),
      );

      // Pre-cache the image file to ensure it's available
      final file = File(widget.imagePath);
      if (!await file.exists()) {
        throw FileSystemException('Image file not found');
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          widget.imagePath,
          filename: 'ocr_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      );

      final response = await request.send().timeout(
            const Duration(seconds: 90),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );

      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData) as Map<String, dynamic>;

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          _textController.text =
              jsonResponse['extracted_text']?.toString() ?? "";
        });
      } else {
        throw http.ClientException(
          'Server error: ${response.statusCode}',
          Uri.parse('http://192.168.1.5:5000/ocr'),
        );
      }
    } on TimeoutException catch (e) {
      _handleError('Request timed out: ${e.message}');
    } on SocketException catch (e) {
      _handleError('Network error: ${e.message}');
    } on http.ClientException catch (e) {
      _handleError('Connection error: ${e.message}');
    } on FormatException catch (e) {
      _handleError('Data format error: ${e.message}');
    } on FileSystemException catch (e) {
      _handleError('File error: ${e.message}');
    } catch (e) {
      _handleError('Unexpected error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleError(String message) {
    if (!mounted) return;
    setState(() => _hasError = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToTtsPage() {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No text extracted. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TtsPage(
          extractedText: _textController.text,
          imagePath: widget.imagePath,
          selectedLanguage: _selectedLanguage,
          selectedGender: _selectedVoice,
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return _SelectionCard(
      title: 'Select Language',
      value: _selectedLanguage,
      items: const ['English', 'German', 'Hindi', 'Japanese', 'Spanish'],
      onChanged: (value) => setState(() => _selectedLanguage = value!),
    );
  }

  Widget _buildVoiceSelector() {
    return _SelectionCard(
      title: 'Select Voice',
      value: _selectedVoice,
      items: const ['Male', 'Female'],
      onChanged: (value) => setState(() => _selectedVoice = value!),
    );
  }

  Widget _buildNextButton() {
    return FloatingActionButton.extended(
      onPressed: _navigateToTtsPage,
      label: const Text(
        'Next',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      icon: const Icon(Icons.arrow_forward),
      backgroundColor: const Color(0xff4CAF50),
    );
  }

  Widget _buildRetryButton() {
    return ElevatedButton.icon(
      onPressed: _sendImageToServer,
      icon: const Icon(Icons.refresh),
      label: const Text('Retry'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff4CAF50),
        foregroundColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F2F5),
      appBar: AppBar(
        title: const Text(
          'OCR Result',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xff4CAF50),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Friendly reminder note
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xffE3F2FD),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xffBBDEFB)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: Color(0xff1976D2)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Scroll down to select language and voice',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Image Preview
                  _ImagePreview(imagePath: widget.imagePath),
                  const SizedBox(height: 20),

                  // Extracted Text Field
                  TextField(
                    controller: _textController,
                    maxLines: 10,
                    minLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      labelText: 'Extracted Text',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    readOnly: false,
                  ),

                  if (_hasError) ...[
                    const SizedBox(height: 20),
                    _buildRetryButton(),
                  ],

                  const SizedBox(height: 20),
                  _buildLanguageSelector(),
                  const SizedBox(height: 20),
                  _buildVoiceSelector(),
                  const SizedBox(height: 80), // Space for FAB
                ],
              ),
            ),
      floatingActionButton: _isLoading || _hasError ? null : _buildNextButton(),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final String imagePath;

  const _ImagePreview({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: Future.value(File(imagePath)),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                snapshot.data!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const _PlaceholderWidget(),
              ),
            ),
          );
        }
        return const _PlaceholderWidget();
      },
    );
  }
}

class _PlaceholderWidget extends StatelessWidget {
  const _PlaceholderWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final String title;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _SelectionCard({
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xffEDEDED),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xffEDEDED),
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

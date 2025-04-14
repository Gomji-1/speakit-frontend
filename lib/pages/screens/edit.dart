import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'ocr.dart';

class ImageEditPage extends StatefulWidget {
  final String imagePath;

  const ImageEditPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  _ImageEditPageState createState() => _ImageEditPageState();
}

class _ImageEditPageState extends State<ImageEditPage> {
  late String editedImagePath;
  List<String> editHistory = [];
  double rotationAngle = 0;
  bool showOriginal = false;
  bool isProcessing = false;
  double _processingProgress = 0;

  @override
  void initState() {
    super.initState();
    editedImagePath = widget.imagePath;
    editHistory.add(widget.imagePath);
  }

  Future<void> _saveCurrentState() async {
    editHistory.add(editedImagePath);
    if (editHistory.length > 10) {
      editHistory.removeAt(0);
    }
  }

  Future<void> _undoEdit() async {
    if (editHistory.length > 1 && !isProcessing) {
      setState(() {
        editHistory.removeLast();
        editedImagePath = editHistory.last;
        rotationAngle = 0;
      });
    }
  }

  Future<void> _rotateImage({bool clockwise = true}) async {
    if (isProcessing) return;
    setState(() {
      isProcessing = true;
      _processingProgress = 0;
      rotationAngle =
          clockwise ? (rotationAngle + 90) % 360 : (rotationAngle - 90) % 360;
    });

    // Simulate progress for smoother transition
    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 20));
      setState(() => _processingProgress = i / 10);
    }

    try {
      final bytes = await File(editedImagePath).readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      if (image == null) throw Exception('Failed to decode image');

      image = img.copyRotate(image, angle: clockwise ? 90 : -90);

      final tempDir = await getTemporaryDirectory();
      final file = File(
          '${tempDir.path}/rotated_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await file.writeAsBytes(img.encodeJpg(image));

      await _saveCurrentState();
      setState(() => editedImagePath = file.path);
    } catch (e) {
      // Silent fail - no popup
    } finally {
      setState(() {
        isProcessing = false;
        _processingProgress = 0;
      });
    }
  }

  Future<void> _cropImage() async {
    if (isProcessing) return;
    setState(() {
      isProcessing = true;
      _processingProgress = 0;
    });

    // Simulate progress
    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      setState(() => _processingProgress = i / 10);
    }

    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: editedImagePath,
        compressQuality: 85,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.white,
            toolbarWidgetColor: Colors.black87,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            cropStyle: CropStyle.rectangle,
            showCropGrid: true,
            hideBottomControls: false,
            statusBarColor: Colors.white,
            backgroundColor: Colors.white,
            activeControlsWidgetColor: Colors.grey[800],
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioPickerButtonHidden: false,
            resetButtonHidden: false,
            rotateButtonsHidden: false,
          ),
        ],
      );

      if (croppedFile != null) {
        await _saveCurrentState();
        setState(() => editedImagePath = croppedFile.path);
      }
    } catch (e) {
      // Silent fail
    } finally {
      setState(() {
        isProcessing = false;
        _processingProgress = 0;
      });
    }
  }

  Future<void> _applyBlackAndWhite() async {
    if (isProcessing) return;
    setState(() {
      isProcessing = true;
      _processingProgress = 0;
    });

    // Simulate progress with incremental updates
    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 40));
      setState(() => _processingProgress = i / 10);
    }

    try {
      final bytes = await File(editedImagePath).readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      if (image == null) throw Exception('Failed to decode image');

      final threshold = 128;
      for (var y = 0; y < image.height; y++) {
        for (var x = 0; x < image.width; x++) {
          final pixel = image.getPixel(x, y);
          final r = pixel.r.toInt();
          final g = pixel.g.toInt();
          final b = pixel.b.toInt();
          final luminance = (0.299 * r + 0.587 * g + 0.114 * b).round();
          final newColor = luminance > threshold ? 255 : 0;
          image.setPixelRgba(x, y, newColor, newColor, newColor, 255);
        }
      }

      final tempDir = await getTemporaryDirectory();
      final file = File(
          '${tempDir.path}/bw_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await file.writeAsBytes(img.encodeJpg(image));

      await _saveCurrentState();
      setState(() => editedImagePath = file.path);
    } catch (e) {
      // Silent fail
    } finally {
      setState(() {
        isProcessing = false;
        _processingProgress = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Edit Image',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed:
                (editHistory.length > 1 && !isProcessing) ? _undoEdit : null,
            tooltip: 'Undo',
          ),
          IconButton(
            icon: Icon(showOriginal ? Icons.toggle_on : Icons.toggle_off),
            onPressed: !isProcessing
                ? () => setState(() => showOriginal = !showOriginal)
                : null,
            tooltip: 'Toggle Original/Edited',
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: !isProcessing
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OcrPage(imagePath: editedImagePath),
                      ),
                    );
                  }
                : null,
            tooltip: 'Done',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: showOriginal
                              ? Image.file(File(widget.imagePath),
                                  key: ValueKey('original'))
                              : Image.file(File(editedImagePath),
                                  key: ValueKey('edited')),
                        ),
                      ),
                      if (isProcessing)
                        Container(
                          color: Colors.black.withOpacity(0.3),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: _processingProgress,
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                  Colors.white.withOpacity(0.8)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(Icons.rotate_left, 'Left', _rotateLeft),
                    _buildActionButton(
                        Icons.rotate_right, 'Right', _rotateRight),
                    _buildActionButton(Icons.crop, 'Crop', _cropImage),
                    _buildActionButton(
                        Icons.invert_colors, 'B&W', _applyBlackAndWhite),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _rotateLeft() => _rotateImage(clockwise: false);
  void _rotateRight() => _rotateImage(clockwise: true);

  Widget _buildActionButton(
      IconData icon, String label, VoidCallback onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: !isProcessing ? onPressed : null,
          tooltip: label,
          color: !isProcessing ? Colors.black87 : Colors.grey[400],
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: !isProcessing ? Colors.black87 : Colors.grey[400],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'info.dart';
import '../components/drawer.dart';
import 'edit.dart';

// Constants (all properly typed)
const double _kAppBarHeight = 56.0;
const double _kOptionCardWidth = 300.0;
const double _kMaxImageDimension = 1920.0; // Fixed as double
const int _kImageQuality = 85;
const Duration _kButtonDelay = Duration(milliseconds: 80);
const Duration _kFadeDuration = Duration(milliseconds: 150);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Static final for class-level cache
  static final _imagePicker = ImagePicker();
  static const _performanceBanner = _PerformanceBanner();
  static const _mainText = _MainText();
  static const _subText = _SubText();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F2F5),
      appBar: _AppBar(),
      drawer: const AppDrawer(),
      body: const Column(
        children: [
          _performanceBanner,
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _mainText,
                  SizedBox(height: 8),
                  _subText,
                  SizedBox(height: 20),
                  _OptionsCard(),
                ],
              ),
            ),
          ),
          _ProTipFooter(),
        ],
      ),
    );
  }
}

// Extracted as constant widgets
class _PerformanceBanner extends StatelessWidget {
  const _PerformanceBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.amber[100],
      child: const Text(
        "Speakit is under development. Server performance may vary.",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: Colors.black87),
      ),
    );
  }
}

class _MainText extends StatelessWidget {
  const _MainText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Capture or Select an Image',
      style: TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _SubText extends StatelessWidget {
  const _SubText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Choose an option below to get started',
      style: TextStyle(
        fontSize: 14,
        color: Colors.black54,
      ),
    );
  }
}

class _OptionsCard extends StatelessWidget {
  const _OptionsCard();

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    await Future.delayed(_kButtonDelay); // Using constant delay

    final image = await HomePage._imagePicker.pickImage(
      source: source,
      maxWidth: _kMaxImageDimension,
      maxHeight: _kMaxImageDimension,
      imageQuality: _kImageQuality,
    );

    if (image != null && context.mounted) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => ImageEditPage(imagePath: image.path),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: _kFadeDuration,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _kOptionCardWidth,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xffEDEDED),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _OptionButton(
            icon: Icons.camera_alt,
            label: 'Camera',
            source: ImageSource.camera,
          ),
          _OptionButton(
            icon: Icons.photo_library,
            label: 'Gallery',
            source: ImageSource.gallery,
          ),
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final ImageSource source;

  const _OptionButton({
    required this.icon,
    required this.label,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () => _OptionsCard()._pickImage(context, source),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(icon, size: 40, color: Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ProTipFooter extends StatelessWidget {
  const _ProTipFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const _RichTipText(),
    );
  }
}

class _RichTipText extends StatelessWidget {
  const _RichTipText();

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(
          fontSize: 14,
          color: Colors.black54,
          height: 1.4,
        ),
        children: [
          TextSpan(
            text: 'Pro Tip: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          TextSpan(
            text: 'For best results, use the ',
          ),
          TextSpan(
            text: 'black & white filter ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: 'after capturing picture from camera.',
          ),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(_kAppBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Home',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info, color: Colors.black),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const InfoPage()),
          ),
        ),
      ],
    );
  }
}

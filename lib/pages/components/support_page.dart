import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for Clipboard functionality

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  // Constants for reusable styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle descriptionStyle = TextStyle(
    fontSize: 14,
    color: Colors.black54,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.black,
  );

  void _showQRDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor:
                Colors.white, // Set dialog background to white
          ),
          child: AlertDialog(
            backgroundColor: Colors.white, // Ensure background is white
            title: const Text(
              'Scan QR Code',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/paytm_qr.png',
                  width: 150,
                  height: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, color: Colors.red);
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  'Scan the QR code using Paytm or any UPI app to support the app.',
                  style: descriptionStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'OR',
                  style: descriptionStyle,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Send directly to UPI ID:',
                  style: descriptionStyle,
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(
                        const ClipboardData(text: '9015077257@pthdfc'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('UPI ID copied to clipboard!'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Copy UPI ID'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F2F5),
      appBar: AppBar(
        title: const Text(
          'Support the App',
          style: headingStyle,
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Professional Heading
            const Text(
              'Support App Development',
              style: headingStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Subtle Description
            const Text(
              'If you find this app valuable, consider supporting its development. Your contribution helps cover server costs, maintenance, and future updates.',
              style: descriptionStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Wolverine Reference
            const Text(
              'Keepin\' this app runnin\' ain\'t cheap, bub.',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Button to Show QR Code and UPI ID
            ElevatedButton(
              onPressed: () => _showQRDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Support via Paytm/UPI'),
            ),
            const SizedBox(height: 20),

            // Close Button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

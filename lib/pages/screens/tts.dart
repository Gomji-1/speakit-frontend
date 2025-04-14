import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as path;
import 'home.dart'; // Replace with your actual package name

class TtsPage extends StatefulWidget {
  final String imagePath;
  final String extractedText;
  final String selectedLanguage;
  final String selectedGender;

  const TtsPage({
    super.key,
    required this.imagePath,
    required this.extractedText,
    required this.selectedLanguage,
    required this.selectedGender,
  });

  @override
  State<TtsPage> createState() => _TtsPageState();
}

class _TtsPageState extends State<TtsPage> {
  late String selectedLanguage;
  late String selectedGender;
  String? audioFilePath;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;
  double _playbackSpeed = 1.0;
  double _volume = 1.0;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isSeeking = false;

  @override
  void initState() {
    super.initState();
    selectedLanguage = widget.selectedLanguage;
    selectedGender = widget.selectedGender;
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((Duration position) {
      if (!_isSeeking && mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _generateAudio() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
    }

    setState(() {
      _isLoading = true;
      _position = Duration.zero;
      audioFilePath = null;
    });

    try {
      final request = http.Request(
        'POST',
        Uri.parse('http://54.179.204.181:5000/tts'),
      )
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({
          "text": widget.extractedText,
          "language": selectedLanguage,
          "gender": selectedGender,
        });

      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/audio_output.mp3';
        final file = File(filePath);

        final sink = file.openWrite();
        await for (var chunk in streamedResponse.stream) {
          sink.add(chunk);
        }
        await sink.close();

        if (mounted) {
          setState(() {
            audioFilePath = filePath;
            _isLoading = false;
          });
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Audio generated successfully! — scroll down')),
          );
        }
      } else {
        throw Exception(
            'Failed to generate audio: ${streamedResponse.reasonPhrase}');
      }
    } on SocketException {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connection error. Please try again.')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _togglePlayPause() async {
    if (audioFilePath != null) {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(DeviceFileSource(audioFilePath!));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No audio file found.')),
      );
    }
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    if (mounted) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    }
  }

  Future<void> _downloadAudio() async {
    if (audioFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No audio file found.')),
      );
      return;
    }

    try {
      Directory? targetDirectory;

      if (Platform.isAndroid) {
        targetDirectory = Directory('/storage/emulated/0/Download');
        if (!await targetDirectory.exists()) {
          targetDirectory = await getExternalStorageDirectory();
          targetDirectory = Directory('${targetDirectory?.path}/Download');
          if (!await targetDirectory.exists()) {
            targetDirectory = await getDownloadsDirectory();
          }
        }
      } else if (Platform.isIOS) {
        targetDirectory = await getApplicationDocumentsDirectory();
      }

      if (targetDirectory == null || !await targetDirectory.exists()) {
        throw Exception('Could not access downloads directory');
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'audio_$timestamp.mp3';
      final downloadPath = path.join(targetDirectory.path, fileName);

      final sourceFile = File(audioFilePath!);
      await sourceFile.copy(downloadPath);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Audio downloaded successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _shareAudio() async {
    if (audioFilePath != null) {
      final file = File(audioFilePath!);
      if (await file.exists()) {
        await Share.shareXFiles([XFile(file.path)],
            text: 'Check out this audio file!');
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Audio file not found.')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No audio file generated yet.')),
        );
      }
    }
  }

  void _setPlaybackSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
    });
    _audioPlayer.setPlaybackRate(speed);
  }

  void _setVolume(double volume) {
    setState(() {
      _volume = volume;
    });
    _audioPlayer.setVolume(volume);
  }

  void _seekToPosition(double value) async {
    final newPosition = Duration(seconds: value.toInt());

    setState(() {
      _isSeeking = true;
      _position = newPosition;
    });

    await _audioPlayer.seek(newPosition);

    if (mounted) {
      setState(() {
        _isSeeking = false;
      });
    }
  }

  Widget _buildPlaybackControls() {
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 40,
                  ),
                  onPressed: _togglePlayPause,
                  color: const Color(0xff4CAF50),
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.stop, size: 40),
                  onPressed: _stopAudio,
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Slider(
              value: _position.inSeconds.toDouble(),
              min: 0,
              max: _duration.inSeconds.toDouble(),
              onChanged: _seekToPosition,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(_position),
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    _formatDuration(_duration),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Speed: '),
                Expanded(
                  child: Slider(
                    value: _playbackSpeed,
                    min: 0.5,
                    max: 2.0,
                    divisions: 3,
                    onChanged: _setPlaybackSpeed,
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Text('${_playbackSpeed}x'),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Volume: '),
                Expanded(
                  child: Slider(
                    value: _volume,
                    min: 0,
                    max: 1,
                    onChanged: _setVolume,
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Text('${(_volume * 100).toInt()}%'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F2F5),
      appBar: AppBar(
        title: const Text(
          'TTS Result',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Image Container
              Container(
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
                    File(widget.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Extracted Text Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Extracted Text:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 150,
                      child: SingleChildScrollView(
                        child: Text(
                          widget.extractedText,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(
                    color: Color(0xff4CAF50),
                  ),
                )
              else if (audioFilePath != null) ...[
                _buildPlaybackControls(),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _downloadAudio,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff4CAF50),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Download',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _shareAudio,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2196F3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Share',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFF5722),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Home',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateAudio,
        backgroundColor: const Color(0xff4CAF50),
        tooltip: 'Generate audio file',
        child: const Icon(Icons.audio_file),
      ),
    );
  }
}

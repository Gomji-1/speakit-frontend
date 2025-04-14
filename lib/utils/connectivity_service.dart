import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService extends StatefulWidget {
  final Widget child;

  const ConnectivityService({super.key, required this.child});

  @override
  State<ConnectivityService> createState() => _ConnectivityServiceState();
}

class _ConnectivityServiceState extends State<ConnectivityService> {
  List<ConnectivityResult> _previousResult = [
    ConnectivityResult.none
  ]; // Track previous connectivity state

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    Connectivity().onConnectivityChanged.listen((results) {
      _handleConnectivityChange(results); // Handle connectivity changes
    });
  }

  Future<void> _checkInitialConnection() async {
    List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    _previousResult = results; // Set initial state
    if (results.contains(ConnectivityResult.none)) {
      _showSnackbar('No internet connection', Colors.red);
    }
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none)) {
      // If there's no internet, show "No internet connection"
      _showSnackbar('No internet connection', Colors.red);
    } else if (_previousResult.contains(ConnectivityResult.none)) {
      // If internet was previously unavailable and is now restored, show "Internet restored"
      _showSnackbar('Internet restored', Colors.green);
    }
    _previousResult = results; // Update the previous state
  }

  void _showSnackbar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

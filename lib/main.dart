import 'package:flutter/material.dart';
import 'welcome.dart'; // Import your SplashScreen
import 'pages/screens/home.dart'; // Import your HomePage
import 'utils/connectivity_service.dart'; // Import your ConnectivityService

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      // Set SplashScreen as the initial route
      home: SplashScreen(),
      // Define your routes
      routes: {
        '/home': (context) => ConnectivityService(child: const HomePage()),
      },
    );
  }
}

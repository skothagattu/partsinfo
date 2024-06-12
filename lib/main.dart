import 'package:flutter/material.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/designServices/DesignServices.dart';
import 'Screens/library/LibraryPage.dart';
import 'Screens/purchasing/PurchasingPage.dart'; // Import the new library page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/purchasing': (context) => const PurchasingScreen(),
        '/designservices': (context) => const DesignServicesScreen(),
        '/library': (context) => const LibraryPage(), // Add the new library page
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) => const HomeScreen());
        } else if (settings.name == '/purchasing') {
          return MaterialPageRoute(builder: (context) => const PurchasingScreen());
        } else if (settings.name == '/designservices') {
          return MaterialPageRoute(builder: (context) => const DesignServicesScreen());
        } else if (settings.name == '/library') {
          return MaterialPageRoute(builder: (context) => const LibraryPage());
        }
        return null;
      },
    );
  }
}

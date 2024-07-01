import 'package:flutter/material.dart';
import 'Screens/CabAireDWGNumbersFormScreen.dart';
import 'Screens/D03NumbersFormScreen.dart';
import 'Screens/DWGNumbersFormScreen.dart';
import 'Screens/EcoLogFormScreen.dart';
import 'Screens/EcrLogFormScreen.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/PartSubLogFormScreen.dart';
import 'Screens/designServices/DesignServices.dart';
import 'Screens/library/LibraryPage.dart';
import 'Screens/purchasing/PurchasingPage.dart';
import 'Screens/purchasing/ThreeLetterCodeFormScreen.dart'; // Import the new screen

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
        '/library': (context) => const LibraryPage(),
        '/threelettercodeform': (context) => const ThreeLetterCodeFormScreen(), // Add the new route
        '/partsublogform': (context) => PartSubLogFormScreen(),
        '/d03numbersform': (context) => D03NumbersFormScreen(),
        '/dwgnumbersform': (context) => const DWGNumbersFormScreen(),
        '/cabairedwgnumbersform': (context) => CabAireDWGNumberFormScreen(),
        '/ecologform': (context) => EcoLogFormScreen(),
        '/ecrlogform': (context) => EcrLogFormScreen(),
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
        } else if (settings.name == '/threelettercodeform') {
          return MaterialPageRoute(builder: (context) => const ThreeLetterCodeFormScreen());
        } else if (settings.name == '/d03numbersform') {
          return MaterialPageRoute(builder: (context) => const D03NumbersFormScreen());
        } else if (settings.name == '/dwgnumbersform') {
          return MaterialPageRoute(builder: (context) => const DWGNumbersFormScreen());
        } else if (settings.name == '/ecologform') {
          return MaterialPageRoute(builder: (context) => const EcoLogFormScreen());
        }
        return null;
      },
    );
  }
}

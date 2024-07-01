import 'package:flutter/material.dart';
import 'dart:js' as js;

import 'CabAireDWGNumbersFormScreen.dart';
import 'D03NumbersFormScreen.dart';
import 'DWGNumbersFormScreen.dart';
import 'EcoLogFormScreen.dart';
import 'EcrLogFormScreen.dart';
import 'PartSubLogFormScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      js.context.callMethod('eval', ['document.title = "PARTS INFO"']);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'PARTS INFO',
                style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2, // Adjust the aspect ratio to make the items smaller
                ),
                children: [
                  _buildButton(context, 'PURCHASING', Colors.lightBlue, () {
                    _openNewTab('/purchasing', 'Purchasing');
                  }),
                  // _buildButton(context, 'DESIGN SERVICES', Colors.blue, () {
                  //   _openNewTab('/designservices', 'Design Services');
                  // }),
                  _buildButton(context, 'DESIGN SERVICES', Colors.grey, null, isDisabled: true),

                  _buildButton(context, 'LIBRARY', Colors.indigo, () {
                    _openNewTab('/library', 'Library');
                  }),
                  _buildButton(context, 'PART SUB LOG', Colors.cyan, () {
                    _openFormPopup(context, PartSubLogFormScreen());
                  }),
                  _buildButton(context, 'CHERYL\'S DO3 REPORT', Colors.blueAccent, null),
                  _buildButton(context, 'DO3 NUMBERS', Colors.lightBlueAccent, () {
                    _openFormPopup(context, D03NumbersFormScreen());
                  }),
                  _buildButton(context, 'DWG NUMBERS', Colors.deepPurpleAccent, () {
                    _openFormPopup(context, DWGNumbersFormScreen());
                  }),
                  _buildButton(context, 'ECO LOG', Colors.teal, () {
                    _openFormPopup(context, EcoLogFormScreen());
                  }),
                  Container(), // Empty container to push the last two buttons to the right
                  Container(), // Another empty container to push the last two buttons to the right
                  _buildButton(context, 'CAB AIRE DWG NUMBERS', Colors.lightBlue, () {
                    _openFormPopup(context, CabAireDWGNumberFormScreen());
                  }),
                  _buildButton(context, 'ECR LOG', Colors.deepPurple, () {
                    _openFormPopup(context, EcrLogFormScreen());
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openNewTab(String page, String title) {
    final currentUrl = Uri.base;
    final newUrl = currentUrl.replace(fragment: page).toString();

    js.context.callMethod('openNewTab', [newUrl, title]);
  }
  void _openFormPopup(BuildContext context, Widget formScreen) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 800,
            height: 800,
            child: formScreen,
          ),
        );
      },
    );
  }

  Widget _buildButton(BuildContext context, String text, Color color, VoidCallback? onTap, {bool isDisabled = false}) {
    return GestureDetector(
      onTap: isDisabled
          ? () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Notice'),
              content: Text('This feature is under development. Please test other options.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
          : onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Adjust padding as needed
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

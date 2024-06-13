import 'package:flutter/material.dart';
import 'dart:js' as js;

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
                  _buildButton(context, 'DESIGN SERVICES', Colors.blue, () {
                    _openNewTab('/designservices', 'Design Services');
                  }),
                  _buildButton(context, 'LIBRARY', Colors.indigo, () {
                    _openNewTab('/library', 'Library');
                  }),
                  _buildButton(context, 'PART SUB LOG', Colors.cyan, null),
                  _buildButton(context, 'CHERYL\'S DO3 REPORT', Colors.blueAccent, null),
                  _buildButton(context, 'DO3 NUMBERS', Colors.lightBlueAccent, null),
                  _buildButton(context, 'DWG NUMBERS', Colors.deepPurpleAccent, null),
                  _buildButton(context, 'ECO LOG', Colors.teal, null),
                  Container(), // Empty container to push the last two buttons to the right
                  Container(), // Another empty container to push the last two buttons to the right
                  _buildButton(context, 'CAB AIRE DWG NUMBERS', Colors.lightBlue, null),
                  _buildButton(context, 'ECR LOG', Colors.deepPurple, null),
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

  Widget _buildButton(BuildContext context, String text, Color color, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
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

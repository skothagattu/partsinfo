import 'package:flutter/material.dart';
import 'dart:js' as js;

import 'ThreeLetterCodeFormScreen.dart';

class PurchasingScreen extends StatelessWidget {
  const PurchasingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      js.context.callMethod('eval', ['document.title = "Purchasing"']);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            js.context.callMethod('eval', ['document.title = "PARTS INFO"']);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Text(
                'CMI PART NUMBER INFORMATION AND HISTORY',
                style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildSection(context, 'HISTORY', Colors.pink, [
                          'CMI NO',
                          'MFG CODE',
                          'MFG NO',
                          'ORDER DATE',
                          'PO NO',
                          'VEND CODE',
                          'HISTORY REPORT',
                        ], Colors.grey)),
                        SizedBox(width: 16), // Gap between sections
                        Expanded(child: _buildSection(context, 'STANDARD PARTS BOOK', Colors.pink, [
                          'LOOK UP BY CMI NO',
                          'LOOK UP BY MFG NO',
                          'STANDARD PART LOOK UP',
                        ], Colors.grey)),
                      ],
                    ),
                  ),
                  SizedBox(height: 16), // Gap between rows
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildSection(context, '3 LETTER CODE', Colors.pink, [
                          '3 LETTER CODE BY CODE',
                          '3 LETTER CODE BY COMPANY',
                          'REPORT FOR SINGLE CODE',
                          'LOOK UP, ADD AND EDIT',
                        ], Colors.grey)),
                        SizedBox(width: 16), // Gap between sections
                        Expanded(child: _buildSection(context, 'SAMPLES', Colors.pink, [
                          'SAMPLES',
                          'SAMPLES REPORT',
                        ], Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Color titleColor, List<String> labels, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200], // Light grey background
        border: Border.all(color: Colors.grey[400]!, width: 1), // Slightly darker grey border
        borderRadius: BorderRadius.circular(8),
        boxShadow: [ // 3D effect
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(8.0), // Adjust padding as needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center the heading
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, color: titleColor, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 3;
                double itemWidth = (constraints.maxWidth - (crossAxisCount - 1) * 10) / crossAxisCount;
                double itemHeight = 50; // Fixed height for buttons
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: itemWidth / itemHeight,
                  children: labels.map((label) => _buildPurchasingButton(context, label, color)).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchasingButton(BuildContext context, String text, Color defaultColor) {
    Color buttonColor = defaultColor;
    if (text == 'LOOK UP' || text == 'ADD' || text == 'EDIT' || text == 'LOOK UP, ADD AND EDIT') {
      buttonColor = Colors.green;
    }

    return Center( // Center the button if it's the only item in the last row
      child: GestureDetector(
        onTap: () {
          if (text == 'LOOK UP, ADD AND EDIT') {
            // js.context.callMethod('open', [
            //   '/#/threelettercodeform', // Ensure this path is correct and matches your route
            //   '_blank',
            //   'width=800,height=800'
            // ]);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Container(
                    width: 800,
                    height: 800,
                    child: ThreeLetterCodeFormScreen(),
                  ),
                );
              },
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$text pressed')));
          }
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

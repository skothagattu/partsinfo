import 'package:flutter/material.dart';
import 'dart:js' as js;

class DesignServicesScreen extends StatelessWidget {
  const DesignServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      js.context.callMethod('eval', ['document.title = "Design Services"']);
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  'CMI PART NUMBER INFORMATION AND HISTORY',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'STANDARD PARTS BOOK',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            _buildSubSection(
                              context,
                              'REPORTS',
                              Colors.purple, // Sub-compartment heading color
                              [
                                'REPORT BY CMI NO',
                                'REPORT BY MFG NO',
                                'ADDENDUM CMI',
                                'ADDENDUM MFG',
                              ],
                              Colors.lightBlue,
                            ),
                            SizedBox(height: 16),
                            _buildSubSection(
                              context,
                              'MAINTENANCE',
                              Colors.purple, // Sub-compartment heading color
                              [
                                'MAINTAIN STD PART BOOK',
                                'PRINT PAGE',
                              ],
                              Colors.lightBlue,
                            ),
                            SizedBox(height: 16),
                            _buildSubSection(
                              context,
                              'LOOKUP',
                              Colors.purple, // Sub-compartment heading color
                              [
                                'IF YOU KNOW CMI NO',
                                'IF YOU KNOW MFG NO',
                                'LOOK-UP BY ANYTHING',
                              ],
                              Colors.lightBlue,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16), // Gap between sections
                      Expanded(
                        child: Column(
                          children: [
                            _buildSection(
                              context,
                              'STANDARD PART BOOK INDEX',
                              Colors.blue,
                              [
                                'REPORT BY TITLE',
                                'ADD TO OR MODIFY INDEX',
                                'REPORT BY NUMBER',
                              ],
                              Colors.blue,
                            ),
                            SizedBox(height: 10), // Gap between sections
                            _buildSection(
                              context,
                              'MB LIST',
                              Colors.orange,
                              [
                                'REPORT BY MB NUMBER',
                                'REPORT BY DO3 NUMBER',
                                'DSP LOG',
                                'ADD NEW MB',
                                'MF INFO INPUT',
                                'MF INFO REPORT',
                              ],
                              Colors.orange,
                            ),
                            SizedBox(height: 10), // Gap between sections
                            _buildSection(
                              context,
                              'PROM',
                              Colors.indigo,
                              [
                                'PROM LISTING',
                                'MODEL BY PROM',
                                'PROM BY MODEL',
                              ],
                              Colors.indigo,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16), // Gap between rows
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(flex: 1),
                      Expanded(
                        flex: 2,
                        child: _buildSection(
                          context,
                          'CARD FILE',
                          Colors.teal,
                          [
                            'CARD FILE MAINTANCE',
                            'DO3 REV PEND REPORT',
                            'SUB LOG',
                          ],
                          Colors.teal,
                        ),
                      ),
                      Spacer(flex: 1),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubSection(
      BuildContext context,
      String title,
      Color titleColor,
      List<String> labels,
      Color color,
      ) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 16, color: titleColor, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          _buildGrid(context, labels, color),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context,
      String title,
      Color titleColor,
      List<String> labels,
      Color color,
      ) {
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
      margin: EdgeInsets.symmetric(vertical: 8), // Vertical margin between sections
      padding: const EdgeInsets.all(8.0), // Adjust padding as needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 18, color: titleColor, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          _buildGrid(context, labels, color),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<String> labels, Color color) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;
        double itemWidth = (constraints.maxWidth - (crossAxisCount - 1) * 10) / crossAxisCount;
        double itemHeight = 50; // Fixed height for buttons
        return GridView.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: itemWidth / itemHeight,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: labels.map((label) => _buildButton(context, label, color)).toList(),
        );
      },
    );
  }

  Widget _buildButton(BuildContext context, String text, Color color) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$text pressed')));
      },
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
    );
  }
}

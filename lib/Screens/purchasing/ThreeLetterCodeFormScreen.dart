import 'package:flutter/material.dart';

class ThreeLetterCodeFormScreen extends StatelessWidget {
  const ThreeLetterCodeFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('3 Letter Code Look Up & Add'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - 100, // Adjust height as needed
            maxWidth: MediaQuery.of(context).size.width - 100, // Adjust width as needed
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: _buildTextField('CODE')),
                    SizedBox(width: 16),
                    Expanded(child: _buildTextField('PHONE')),
                    SizedBox(width: 16),
                    Expanded(child: _buildTextField('FOB')),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildTextField('TYPE')),
                    SizedBox(width: 16),
                    Expanded(child: _buildTextField('EXT 1')),
                    SizedBox(width: 16),
                    Expanded(child: _buildTextField('NOTES', maxLines: 3)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildTextField('COMPANY')),
                    SizedBox(width: 16),
                    Expanded(child: _buildTextField('CONTACT 2')),
                    SizedBox(width: 16),
                    Expanded(child: SizedBox.shrink()),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildTextField('ADDRESS 1')),
                    SizedBox(width: 16),
                    Expanded(child: _buildTextField('PHONE')),
                    SizedBox(width: 16),
                    Expanded(child: SizedBox.shrink()),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildTextField('ADDRESS 2')),
                    SizedBox(width: 16),
                    Expanded(child: _buildTextField('EXT 2')),
                    SizedBox(width: 16),
                    Expanded(child: SizedBox.shrink()),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildTextField('CITY,STATE,ZIP')),
                    SizedBox(width: 16),
                    Expanded(child: _buildTextField('FAX')),
                    SizedBox(width: 16),
                    Expanded(child: SizedBox.shrink()),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildTextField('CONTACT 1')),
                    SizedBox(width: 16),
                    Expanded(child: _buildTextField('TERMS')),
                    SizedBox(width: 16),
                    Expanded(child: SizedBox.shrink()),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle form submission here
                    },
                    child: Text('Submit'),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.first_page),
                      onPressed: () {
                        // Handle first button press
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.navigate_before),
                      onPressed: () {
                        // Handle previous button press
                      },
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.navigate_next),
                      onPressed: () {
                        // Handle next button press
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.last_page),
                      onPressed: () {
                        // Handle last button press
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

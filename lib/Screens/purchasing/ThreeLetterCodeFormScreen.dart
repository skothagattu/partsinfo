import 'package:flutter/material.dart';
import 'package:partsinfo1/models/three_letter_code.dart';
import '../../services/api_service_three_letter_code.dart';

class ThreeLetterCodeFormScreen extends StatefulWidget {
  const ThreeLetterCodeFormScreen({super.key});

  @override
  _ThreeLetterCodeFormScreenState createState() => _ThreeLetterCodeFormScreenState();
}

class _ThreeLetterCodeFormScreenState extends State<ThreeLetterCodeFormScreen> {
  final ApiService apiService = ApiService();
  ThreeLetterCode? currentCode;
  bool isLoading = true;
  String errorMessage = '';
  bool isNewCodeTransactionActive = false; // New state variable

  final TextEditingController codeController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityStateZipController = TextEditingController();
  final TextEditingController contact1Controller = TextEditingController();
  final TextEditingController phone1Controller = TextEditingController();
  final TextEditingController ext1Controller = TextEditingController();
  final TextEditingController contact2Controller = TextEditingController();
  final TextEditingController phone2Controller = TextEditingController();
  final TextEditingController ext2Controller = TextEditingController();
  final TextEditingController faxController = TextEditingController();
  final TextEditingController termsController = TextEditingController();
  final TextEditingController fobController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  @override

  void initState() {
    super.initState();
    _loadFirstCode();
  }
  void _populateFields() {
    if (currentCode != null) {
      codeController.text = currentCode!.code;
      typeController.text = currentCode!.type;
      companyController.text = currentCode!.company;
      address1Controller.text = currentCode!.addresS1;
      address2Controller.text = currentCode!.addresS2;
      cityStateZipController.text = currentCode!.citY_STATE_ZIP;
      contact1Controller.text = currentCode!.contacT1;
      phone1Controller.text = currentCode!.phonE1;
      ext1Controller.text = currentCode!.exT1;
      contact2Controller.text = currentCode!.contacT2;
      phone2Controller.text = currentCode!.phonE2;
      ext2Controller.text = currentCode!.exT2;
      faxController.text = currentCode!.fax;
      termsController.text = currentCode!.terms;
      fobController.text = currentCode!.fob;
      notesController.text = currentCode!.notes;
    }
  }
  Future<void> _loadFirstCode() async {
    setState(() {
      isLoading = true;
    });
    try {
      final code = await apiService.fetchFirstCode();  // Fetch the first code using the new method
      setState(() {
        currentCode = code;
        _populateFields();
        isLoading = false;
        errorMessage = '';
      });
      print('Loaded first code: ${code.code}');
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load data: $e';
      });
      print('Error: $e');
    }
  }

  Future<void> _loadNextCode() async {
    if (isNewCodeTransactionActive) {
      _showUnsavedChangesDialog();
      return;
    }
    if (currentCode != null) {
      setState(() {
        isLoading = true;
      });
      try {
        final code = await apiService.fetchNextCode(currentCode!.code);
        setState(() {
          currentCode = code;
          _populateFields();
          isLoading = false;
          errorMessage = '';
        });
        print('Loaded next code: ${code.code}');
      } catch (e) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load data: $e';
        });
        print('Error: $e');
      }
    }
  }

  Future<void> _loadPreviousCode() async {
    if (isNewCodeTransactionActive) {
      _showUnsavedChangesDialog();
      return;
    }
    if (currentCode != null && currentCode!.position > 1) {
      setState(() {
        isLoading = true;
      });
      try {
        final code = await apiService.fetchPreviousCode(currentCode!.code);
        setState(() {
          currentCode = code;
          _populateFields();
          isLoading = false;
          errorMessage = '';
        });
        print('Loaded previous code: ${code.code}');
      } catch (e) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load data: $e';
        });
        print('Error: $e');
      }
    }
  }
  void _createNewCode() {
    if (isNewCodeTransactionActive) {
      _showNewCodeAlert();
      return;
    }
    setState(() {
      currentCode = ThreeLetterCode(
        code: '',
        type: '',
        company: '',
        addresS1: '',
        addresS2: '',
        citY_STATE_ZIP: '',
        contacT1: '',
        phonE1: '',
        exT1: '',
        contacT2: '',
        phonE2: '',
        exT2: '',
        fax: '',
        terms: '',
        fob: '',
        notes: '',
        position: currentCode!.total + 1,
        total: currentCode!.total + 1,
      );
      _clearFields();
      isNewCodeTransactionActive = true;
    });
  }
  void _clearFields() {
    codeController.clear();
    typeController.clear();
    companyController.clear();
    address1Controller.clear();
    address2Controller.clear();
    cityStateZipController.clear();
    contact1Controller.clear();
    phone1Controller.clear();
    ext1Controller.clear();
    contact2Controller.clear();
    phone2Controller.clear();
    ext2Controller.clear();
    faxController.clear();
    termsController.clear();
    fobController.clear();
    notesController.clear();
  }
  void _submitCode() async {
    setState(() {
      isLoading = true;
    });
    try {
      await apiService.createCode(currentCode!);  // Call the create API
      setState(() {
        isLoading = false;
        errorMessage = '';
        isNewCodeTransactionActive = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to create code: $e';
      });
      print('Error: $e');
    }
  }
  void _showNewCodeAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Unsaved New Code'),
          content: Text('You have an unsaved new code. Would you like to submit it or cancel?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _submitCode();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Unsaved Changes'),
          content: Text('You have unsaved changes. Would you like to submit them or discard?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _loadFirstCode(); // or any other appropriate action
              },
              child: Text('Discard'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _submitCode();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
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
                if (isLoading)
                  Center(child: CircularProgressIndicator())
                else if (errorMessage.isNotEmpty)
                  Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
                else if (currentCode != null)
                    Column(
                      children: [
                        _buildFormFields(),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _submitCode,
                              child: Text('Submit'),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: _createNewCode,
                              child: Icon(Icons.add),
                            ),
                          ],
                        ),

                        // Center(
                        //   child: ElevatedButton(
                        //     onPressed: _submitCode,
                        //     child: Text('Submit'),
                        //   ),
                        // ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.first_page),
                              onPressed: _loadFirstCode,
                            ),
                            IconButton(
                              icon: Icon(Icons.navigate_before),
                              onPressed: currentCode!.position > 1 ? _loadPreviousCode : null,
                            ),
                            Spacer(),
                            if (currentCode != null) Text('${currentCode!.position} of ${currentCode!.total}'),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.navigate_next),
                              onPressed: _loadNextCode,
                            ),
                            IconButton(
                              icon: Icon(Icons.last_page),
                              onPressed: () {
                                // Add functionality to load last code if required
                              },
                            ),
                          ],
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
  Widget _buildFormFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildTextField('CODE', codeController)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('PHONE', phone1Controller)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('FOB', fobController)),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildTextField('TYPE', typeController)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('EXT 1', ext1Controller)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('NOTES', notesController, maxLines: 3)),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildTextField('COMPANY', companyController)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('CONTACT 2', contact2Controller)),
            SizedBox(width: 16),
            Expanded(child: SizedBox.shrink()),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildTextField('ADDRESS 1', address1Controller)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('PHONE', phone1Controller)),
            SizedBox(width: 16),
            Expanded(child: SizedBox.shrink()),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildTextField('ADDRESS 2', address2Controller)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('EXT 2', ext2Controller)),
            SizedBox(width: 16),
            Expanded(child: SizedBox.shrink()),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildTextField('CITY,STATE,ZIP', cityStateZipController)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('FAX', faxController)),
            SizedBox(width: 16),
            Expanded(child: SizedBox.shrink()),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildTextField('CONTACT 1', contact1Controller)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('TERMS', termsController)),
            SizedBox(width: 16),
            Expanded(child: SizedBox.shrink()),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.blue,
            fontStyle: FontStyle.italic,
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
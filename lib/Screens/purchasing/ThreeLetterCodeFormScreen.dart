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
  bool hasUnsavedChanges = false;
  bool isNewCode = false;
  List<ThreeLetterCode> searchResults = [];
  int currentSearchIndex = 0;

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
  final TextEditingController searchController = TextEditingController();

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
      final code = await apiService.fetchFirstCode();
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
  Future<void> _loadLastCode() async {
    setState(() {
      isLoading = true;
    });
    try {
      final code = await apiService.fetchLastCode();
      setState(() {
        currentCode = code;
        _populateFields();
        isLoading = false;
        errorMessage = '';
      });
      print('Loaded Last code: ${code.code}');
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load data: $e';
      });
      print('Error: $e');
    }
  }
  Future<void> _loadNextCode() async {
    if (hasUnsavedChanges && _hasDataInFields()) {
      _showUnsavedChangesDialog(_loadNextCode);
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
    if (hasUnsavedChanges && _hasDataInFields()) {
      _showUnsavedChangesDialog(_loadPreviousCode);
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

  void _createNewCode() async {
    if (hasUnsavedChanges && _hasDataInFields()) {
      _showUnsavedChangesDialog(_createNewCode);
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final lastCode = await apiService.fetchLastCode(); // Ensure you have this method implemented
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
          position: lastCode.total + 1,
          total: lastCode.total + 1,
        );
        _clearFields();
        hasUnsavedChanges = true;
        isNewCode = true;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to create new code: $e';
      });
      print('Error: $e');
    }
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
    setState(() {
      hasUnsavedChanges = false;
      isNewCode = false;
    });
  }


  bool _hasDataInFields() {
    return codeController.text.isNotEmpty ||
        typeController.text.isNotEmpty ||
        companyController.text.isNotEmpty ||
        address1Controller.text.isNotEmpty ||
        address2Controller.text.isNotEmpty ||
        cityStateZipController.text.isNotEmpty ||
        contact1Controller.text.isNotEmpty ||
        phone1Controller.text.isNotEmpty ||
        ext1Controller.text.isNotEmpty ||
        contact2Controller.text.isNotEmpty ||
        phone2Controller.text.isNotEmpty ||
        ext2Controller.text.isNotEmpty ||
        faxController.text.isNotEmpty ||
        termsController.text.isNotEmpty ||
        fobController.text.isNotEmpty ||
        notesController.text.isNotEmpty;
  }

  void _submitCode() async {
    if (!hasUnsavedChanges) return; // Avoid submitting if there are no unsaved changes
    if (codeController.text.isEmpty || typeController.text.isEmpty || companyController.text.isEmpty) {
      setState(() {
        errorMessage = 'Code, Type, and Company are required fields.';
      });
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final newCode = ThreeLetterCode(
        code: codeController.text,
        type: typeController.text,
        company: companyController.text,
        addresS1: address1Controller.text,
        addresS2: address2Controller.text,
        citY_STATE_ZIP: cityStateZipController.text,
        contacT1: contact1Controller.text,
        phonE1: phone1Controller.text,
        exT1: ext1Controller.text,
        contacT2: contact2Controller.text,
        phonE2: phone2Controller.text,
        exT2: ext2Controller.text,
        fax: faxController.text,
        terms: termsController.text,
        fob: fobController.text,
        notes: notesController.text,
        position: currentCode!.position, // Ensure the position is correct
        total: currentCode!.total, // Ensure the total is correct
      );

      await apiService.createCode(newCode);
      setState(() {
        isLoading = false;
        errorMessage = '';
        hasUnsavedChanges = false;
        isNewCode = false; // Reset the new code state
        currentCode = newCode;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorMessageDialog(e.toString());
      print('Error: $e');
    }
  }
  void _showErrorMessageDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearFields();
              },
              child: Text('Discard'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  void _cancelNewCode() {
    setState(() {
      _clearFields();
      isNewCode = false;
      hasUnsavedChanges = false;
      _loadFirstCode();
    });
  }

  void _showUnsavedChangesDialog(VoidCallback proceedAction) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Unsaved Changes'),
          content: Text('You have unsaved changes. Would you like to submit them, discard, or cancel?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  hasUnsavedChanges = false;
                  _clearFields();
                });
                proceedAction();
              },
              child: Text('Discard'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _submitCode();
                proceedAction();
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  void _searchCode() async {
    if (searchController.text.isEmpty) {
      setState(() {
        errorMessage = 'Search field cannot be empty.';
      });
      return;
    }
    setState(() {
      isLoading = true;
      errorMessage = '';
      searchResults.clear();
      currentSearchIndex = 0;
    });
    try {
      final results = await apiService.searchCode(searchController.text);
      setState(() {
        searchResults = results as List<ThreeLetterCode>;
        if (searchResults.isNotEmpty) {
          currentCode = searchResults.first;
          _populateFields();
        } else {
          errorMessage = 'No results found.';
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to search code: $e';
      });
      print('Error: $e');
    }
  }
  void _clearSearch() {
    setState(() {
      searchController.clear();
      searchResults.clear();
      currentSearchIndex = 0;
      _loadFirstCode();
    });
  }
  void _loadNextSearchResult() {
    if (currentSearchIndex < searchResults.length - 1) {
      setState(() {
        currentSearchIndex++;
        currentCode = searchResults[currentSearchIndex];
        _populateFields();
      });
    }
  }

  void _loadPreviousSearchResult() {
    if (currentSearchIndex > 0) {
      setState(() {
        currentSearchIndex--;
        currentCode = searchResults[currentSearchIndex];
        _populateFields();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('3 Letter Code Look Up & Add'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - 100,
            maxWidth: MediaQuery.of(context).size.width - 100,
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
                        _buildSearchBar(),
                        SizedBox(height: 20),
                        _buildFormFields(),
                        SizedBox(height: 20),
                        if (!isNewCode)
                          ElevatedButton(
                            onPressed: _createNewCode,
                            child: Icon(Icons.add),
                          ),
                        if (isNewCode)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: _submitCode,
                                child: Text('Submit'),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: _clearFields,
                                child: Text('Clear'),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: _cancelNewCode,
                                child: Text('Cancel'),
                              ),
                            ],
                          ),
                        SizedBox(height: 20),
                        if (searchResults.isEmpty || searchResults.length == 1)
                          _buildNavigationButtons(),
                        if (searchResults.length > 1)
                          _buildSearchNavigationButtons(),
                        /*Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.first_page),
                              onPressed: isNewCode
                                  ? null
                                  : () {
                                if (hasUnsavedChanges && _hasDataInFields()) {
                                  _showUnsavedChangesDialog(_loadFirstCode);
                                } else {
                                  _loadFirstCode();
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.navigate_before),
                              onPressed: isNewCode
                                  ? null
                                  : currentCode!.position > 1
                                  ? () {
                                if (hasUnsavedChanges && _hasDataInFields()) {
                                  _showUnsavedChangesDialog(_loadPreviousCode);
                                } else {
                                  _loadPreviousCode();
                                }
                              }
                                  : null,
                            ),
                            Spacer(),
                            if (currentCode != null)
                              Text('${currentCode!.position} of ${currentCode!.total}'),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.navigate_next),
                              onPressed: isNewCode
                                  ? null
                                  : () {
                                if (hasUnsavedChanges && _hasDataInFields()) {
                                  _showUnsavedChangesDialog(_loadNextCode);
                                } else {
                                  _loadNextCode();
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.last_page),
                              onPressed: isNewCode
                                  ? null
                                  : () {
                                if (hasUnsavedChanges && _hasDataInFields()) {
                                  _showUnsavedChangesDialog(_loadLastCode);
                                } else {
                                  _loadLastCode();
                                }
                              },
                            ),
                          ],
                        ),*/
                      ],
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search Code',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: _searchCode,
          child: Text('Search'),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: _clearSearch,
          child: Text('Clear'),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.first_page),
          onPressed: isNewCode
              ? null
              : () {
            if (hasUnsavedChanges && _hasDataInFields()) {
              _showUnsavedChangesDialog(_loadFirstCode);
            } else {
              _loadFirstCode();
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: isNewCode
              ? null
              : currentCode!.position > 1
              ? () {
            if (hasUnsavedChanges && _hasDataInFields()) {
              _showUnsavedChangesDialog(_loadPreviousCode);
            } else {
              _loadPreviousCode();
            }
          }
              : null,
        ),
        Spacer(),
        if (currentCode != null) Text('${currentCode!.position} of ${currentCode!.total}'),
        Spacer(),
        IconButton(
          icon: Icon(Icons.navigate_next),
          onPressed: isNewCode
              ? null
              : () {
            if (hasUnsavedChanges && _hasDataInFields()) {
              _showUnsavedChangesDialog(_loadNextCode);
            } else {
              _loadNextCode();
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.last_page),
          onPressed: isNewCode
              ? null
              : () {
            if (hasUnsavedChanges && _hasDataInFields()) {
              _showUnsavedChangesDialog(_loadLastCode);
            } else {
              _loadLastCode();
            }
          },
        ),
      ],
    );
  }

  Widget _buildSearchNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: currentSearchIndex > 0 ? _loadPreviousSearchResult : null,
        ),
        Text('${currentSearchIndex + 1} of ${searchResults.length}'),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: currentSearchIndex < searchResults.length - 1 ? _loadNextSearchResult : null,
        ),
      ],
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
        onChanged: (value) {
          setState(() {
            hasUnsavedChanges = true;
          });
        },
      ),
    );
  }
}
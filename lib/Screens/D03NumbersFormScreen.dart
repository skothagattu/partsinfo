import 'package:flutter/material.dart';
import '../services/api_service_d03_numbers.dart';
import '../models/d03_numbers.dart';

class D03NumbersFormScreen extends StatefulWidget {
  const D03NumbersFormScreen({super.key});

  @override
  _D03NumbersFormScreenState createState() => _D03NumbersFormScreenState();
}

class _D03NumbersFormScreenState extends State<D03NumbersFormScreen> {
  final ApiService apiService = ApiService();
  D03numbers? currentNumber;
  D03numbers? originalNumber;
  bool isLoading = true;
  String errorMessage = '';
  bool hasUnsavedChanges = false;
  bool isNewNumber = false;
  List<D03numbers> searchResults = [];
  int currentSearchIndex = 0;

  final TextEditingController idController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController blNumberController = TextEditingController();
  final TextEditingController panelDwgController = TextEditingController();
  final TextEditingController whoController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFirstNumber();
  }

  void _populateFields() {
    if (currentNumber != null) {
      idController.text = currentNumber!.id.toString();
      descriptionController.text = currentNumber!.description;
      blNumberController.text = currentNumber!.bL_NUMBER;
      panelDwgController.text = currentNumber!.paneL_DWG;
      whoController.text = currentNumber!.who;
      startDateController.text = currentNumber!.starT_DATE;
      modelController.text = currentNumber!.model;
      originalNumber = currentNumber?.copy();
    }
  }

  Future<void> _loadFirstNumber() async {
    setState(() {
      isLoading = true;
    });
    try {
      final number = await apiService.fetchFirst();
      setState(() {
        currentNumber = number;
        _populateFields();
        isLoading = false;
        errorMessage = '';
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load data: $e';
      });
      print('Error: $e');
    }
  }

  Future<void> _loadLastNumber() async {
    setState(() {
      isLoading = true;
    });
    try {
      final number = await apiService.fetchLast();
      setState(() {
        currentNumber = number;
        _populateFields();
        isLoading = false;
        errorMessage = '';
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load data: $e';
      });
    }
  }

  Future<void> _loadNextNumber() async {
    if (hasUnsavedChanges && _hasDataInFields()) {
      _showUnsavedChangesDialog(_loadNextNumber);
      return;
    }
    if (currentNumber != null) {
      setState(() {
        isLoading = true;
      });
      try {
        final number = await apiService.fetchNext(currentNumber!.id);
        setState(() {
          currentNumber = number;
          _populateFields();
          isLoading = false;
          errorMessage = '';
        });
      } catch (e) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load data: $e';
        });
      }
    }
  }

  Future<void> _loadPreviousNumber() async {
    if (hasUnsavedChanges && _hasDataInFields()) {
      _showUnsavedChangesDialog(_loadPreviousNumber);
      return;
    }
    if (currentNumber != null && currentNumber!.position > 1) {
      setState(() {
        isLoading = true;
      });
      try {
        final number = await apiService.fetchPrevious(currentNumber!.id);
        setState(() {
          currentNumber = number;
          _populateFields();
          isLoading = false;
          errorMessage = '';
        });
      } catch (e) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load data: $e';
        });
      }
    }
  }

  void _createNewNumber() async {
    if (hasUnsavedChanges && _hasDataInFields()) {
      _showUnsavedChangesDialog(_createNewNumber);
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final lastNumber = await apiService.fetchLast();
      setState(() {
        currentNumber = D03numbers(
          id: 0,
          description: '',
          bL_NUMBER: '',
          paneL_DWG: '',
          who: '',
          starT_DATE: '',
          model: '',
          position: lastNumber.total + 1,
          total: lastNumber.total + 1,
        );
        _clearFields();
        hasUnsavedChanges = true;
        isNewNumber = true;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to create new number: $e';
      });
    }
  }

  void _clearFields() {
    idController.clear();
    descriptionController.clear();
    blNumberController.clear();
    panelDwgController.clear();
    whoController.clear();
    startDateController.clear();
    modelController.clear();
    setState(() {
      hasUnsavedChanges = false;
      isNewNumber = false;
    });
  }

  bool _hasDataInFields() {
    return idController.text.isNotEmpty ||
        descriptionController.text.isNotEmpty ||
        blNumberController.text.isNotEmpty ||
        panelDwgController.text.isNotEmpty ||
        whoController.text.isNotEmpty ||
        startDateController.text.isNotEmpty ||
        modelController.text.isNotEmpty;
  }

  void _submitNumber() async {
    if (!hasUnsavedChanges) return;
    if (descriptionController.text.isEmpty) {
      setState(() {
        errorMessage = 'Description is a required field.';
      });
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final newNumber = D03numbers(
        id: int.tryParse(idController.text) ?? 0,
        description: descriptionController.text,
        bL_NUMBER: blNumberController.text,
        paneL_DWG: panelDwgController.text,
        who: whoController.text,
        starT_DATE: startDateController.text,
        model: modelController.text,
        position: currentNumber!.position,
        total: currentNumber!.total,
      );

      await apiService.createOrUpdate(newNumber);
      setState(() {
        isLoading = false;
        errorMessage = '';
        hasUnsavedChanges = false;
        isNewNumber = false;
        currentNumber = newNumber;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorMessageDialog(e.toString());
    }
  }

  void _submitChanges() async {
    if (!hasUnsavedChanges) return;
    if (currentNumber == null) return;

    setState(() {
      isLoading = true;
    });
    try {
      final updatedNumber = D03numbers(
        id: int.tryParse(idController.text) ?? 0,
        description: descriptionController.text,
        bL_NUMBER: blNumberController.text,
        paneL_DWG: panelDwgController.text,
        who: whoController.text,
        starT_DATE: startDateController.text,
        model: modelController.text,
        position: currentNumber!.position,
        total: currentNumber!.total,
      );

      await apiService.update(currentNumber!.id, updatedNumber);
      setState(() {
        currentNumber = updatedNumber;
        originalNumber = updatedNumber.copy();
        isLoading = false;
        errorMessage = '';
        hasUnsavedChanges = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to update number: $e';
      });
    }
  }

  void _discardChanges() {
    setState(() {
      if (originalNumber != null) {
        currentNumber = originalNumber;
        _populateFields();
      }
      hasUnsavedChanges = false;
    });
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

  void _cancelNewNumber() {
    setState(() {
      _clearFields();
      isNewNumber = false;
      hasUnsavedChanges = false;
      _loadFirstNumber();
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
                _submitNumber();
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

  void _searchNumber() async {
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
      final results = await apiService.search(searchController.text);
      setState(() {
        searchResults = results as List<D03numbers>;
        if (searchResults.isNotEmpty) {
          currentNumber = searchResults.first;
          _populateFields();
        } else {
          errorMessage = 'No results found.';
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to search number: $e';
      });
      print('Error: $e');
    }
  }

  void _clearSearch() {
    setState(() {
      searchController.clear();
      searchResults.clear();
      currentSearchIndex = 0;
      _loadFirstNumber();
    });
  }

  void _loadNextSearchResult() {
    if (currentSearchIndex < searchResults.length - 1) {
      setState(() {
        currentSearchIndex++;
        currentNumber = searchResults[currentSearchIndex];
        _populateFields();
      });
    }
  }

  void _loadPreviousSearchResult() {
    if (currentSearchIndex > 0) {
      setState(() {
        currentSearchIndex--;
        currentNumber = searchResults[currentSearchIndex];
        _populateFields();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('D03 Numbers Form'),
      ),
      body:isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
          padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
               SizedBox(height: 20),
                _buildFormFields(),
                SizedBox(height: 20),
                if (!isNewNumber)
                  Center(
                    child: ElevatedButton(
                      onPressed: _createNewNumber,
                      child: Icon(Icons.add),
                    ),
                  ),
               if (isNewNumber)
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _submitNumber,
                      child: Text('Submit'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _clearFields,
                      child: Text('Clear'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _cancelNewNumber,
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              if (hasUnsavedChanges && !isNewNumber)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _submitChanges,
                      child: Text('Submit Changes'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _discardChanges,
                      child: Text('Discard Changes'),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              if (searchResults.isEmpty || searchResults.length == 1)
                _buildNavigationButtons(),
              if (searchResults.length > 1)
                _buildSearchNavigationButtons(),
            ],
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
              labelText: 'Search Number',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: _searchNumber,
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
          onPressed: isNewNumber || hasUnsavedChanges
              ? null
              : () {
            if (hasUnsavedChanges && _hasDataInFields()) {
              _showUnsavedChangesDialog(_loadFirstNumber);
            } else {
              _loadFirstNumber();
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: isNewNumber || hasUnsavedChanges
              ? null
              : currentNumber!.position > 1
              ? () {
            if (hasUnsavedChanges && _hasDataInFields()) {
              _showUnsavedChangesDialog(_loadPreviousNumber);
            } else {
              _loadPreviousNumber();
            }
          }
              : null,
        ),
        Spacer(),
        if (currentNumber != null) Text('${currentNumber!.position} of ${currentNumber!.total}'),
        Spacer(),
        IconButton(
          icon: Icon(Icons.navigate_next),
          onPressed: isNewNumber || hasUnsavedChanges
              ? null
              : () {
            if (hasUnsavedChanges && _hasDataInFields()) {
              _showUnsavedChangesDialog(_loadNextNumber);
            } else {
              _loadNextNumber();
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.last_page),
          onPressed: isNewNumber || hasUnsavedChanges
              ? null
              : () {
            if (hasUnsavedChanges && _hasDataInFields()) {
              _showUnsavedChangesDialog(_loadLastNumber);
            } else {
              _loadLastNumber();
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
            Expanded(child: _buildTextField('ID', idController)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('Description', descriptionController)),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildTextField('BL Number', blNumberController)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('Panel DWG', panelDwgController)),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildTextField('Who', whoController)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('Start Date', startDateController)),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildTextField('Model', modelController)),
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

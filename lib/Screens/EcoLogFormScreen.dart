import 'package:flutter/material.dart';
import '../Services/api_service_eco_log.dart';
import '../models/eco_log.dart';

class EcoLogFormScreen extends StatefulWidget {
  const EcoLogFormScreen({super.key});

  @override
  _EcoLogFormScreenState createState() => _EcoLogFormScreenState();
}

class _EcoLogFormScreenState extends State<EcoLogFormScreen> {
  final ApiService apiService = ApiService();
  EcoLog? currentRecord;
  EcoLog? originalRecord;
  bool isLoading = true;
  String errorMessage = '';
  bool hasUnsavedChanges = false;
  bool isNewRecord = false;
  List<EcoLog> searchResults = [];
  int currentSearchIndex = 0;

  final TextEditingController noController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController ecrController = TextEditingController();
  final TextEditingController datE_LOGController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController datE_RELController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFirstRecord();
  }

  void _populateFields() {
    if (currentRecord != null) {
      noController.text = currentRecord!.no.toString();
      descController.text = currentRecord!.desc;
      modelController.text = currentRecord!.model;
      ecrController.text = currentRecord!.ecr;
      datE_LOGController.text = currentRecord!.datE_LOG;
      nameController.text = currentRecord!.name;
      datE_RELController.text = currentRecord!.datE_REL;
      originalRecord = currentRecord?.copy();
    }
  }

  Future<void> _loadFirstRecord() async {
    setState(() {
      isLoading = true;
    });
    try {
      final record = await apiService.fetchFirst();
      setState(() {
        currentRecord = record;
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

  Future<void> _loadLastRecord() async {
    setState(() {
      isLoading = true;
    });
    try {
      final record = await apiService.fetchLast();
      setState(() {
        currentRecord = record;
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

  Future<void> _loadNextRecord() async {
    if (hasUnsavedChanges && _hasDataInFields()) {
      _showUnsavedChangesDialog(_loadNextRecord);
      return;
    }
    if (currentRecord != null) {
      setState(() {
        isLoading = true;
      });
      try {
        final record = await apiService.fetchNext(currentRecord!.no);
        setState(() {
          currentRecord = record;
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

  Future<void> _loadPreviousRecord() async {
    if (hasUnsavedChanges && _hasDataInFields()) {
      _showUnsavedChangesDialog(_loadPreviousRecord);
      return;
    }
    if (currentRecord != null && currentRecord!.position > 1) {
      setState(() {
        isLoading = true;
      });
      try {
        final record = await apiService.fetchPrevious(currentRecord!.no);
        setState(() {
          currentRecord = record;
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

  void _createNewRecord() async {
    if (hasUnsavedChanges && _hasDataInFields()) {
      _showUnsavedChangesDialog(_createNewRecord);
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final lastRecord = await apiService.fetchLast();
      setState(() {
        currentRecord = EcoLog(
          no: 0,
          desc: '',
          model: '',
          ecr: '',
          datE_LOG: '',
          name: '',
          datE_REL: '',
          position: lastRecord.total + 1,
          total: lastRecord.total + 1,
        );
        _clearFields();
        hasUnsavedChanges = true;
        isNewRecord = true;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to create new record: $e';
      });
    }
  }

  void _clearFields() {
    noController.clear();
    descController.clear();
    modelController.clear();
    ecrController.clear();
    datE_LOGController.clear();
    nameController.clear();
    datE_RELController.clear();
    setState(() {
      hasUnsavedChanges = false;
      isNewRecord = false;
    });
  }

  bool _hasDataInFields() {
    return noController.text.isNotEmpty ||
        descController.text.isNotEmpty ||
        modelController.text.isNotEmpty ||
        ecrController.text.isNotEmpty ||
        datE_LOGController.text.isNotEmpty ||
        nameController.text.isNotEmpty ||
        datE_RELController.text.isNotEmpty;
  }

  void _submitRecord() async {
    if (!hasUnsavedChanges) return;
    if (descController.text.isEmpty) {
      setState(() {
        errorMessage = 'DESC is a required field.';
      });
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final newRecord = EcoLog(
        no: int.parse(noController.text),
        desc: descController.text,
        model: modelController.text,
        ecr: ecrController.text,
        datE_LOG: datE_LOGController.text,
        name: nameController.text,
        datE_REL: datE_RELController.text,
        position: currentRecord!.position,
        total: currentRecord!.total,
      );

      await apiService.createOrUpdate(newRecord);
      setState(() {
        isLoading = false;
        errorMessage = '';
        hasUnsavedChanges = false;
        isNewRecord = false;
        currentRecord = newRecord;
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
    if (currentRecord == null) return;

    setState(() {
      isLoading = true;
    });
    try {
      final updatedRecord = EcoLog(
        no: int.parse(noController.text),
        desc: descController.text,
        model: modelController.text,
        ecr: ecrController.text,
        datE_LOG: datE_LOGController.text,
        name: nameController.text,
        datE_REL: datE_RELController.text,
        position: currentRecord!.position,
        total: currentRecord!.total,
      );

      await apiService.update(currentRecord!.no, updatedRecord);
      setState(() {
        currentRecord = updatedRecord;
        originalRecord = updatedRecord.copy();
        isLoading = false;
        errorMessage = '';
        hasUnsavedChanges = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to update record: $e';
      });
    }
  }

  void _discardChanges() {
    setState(() {
      if (originalRecord != null) {
        currentRecord = originalRecord;
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

  void _cancelNewRecord() {
    setState(() {
      _clearFields();
      isNewRecord = false;
      hasUnsavedChanges = false;
      _loadFirstRecord();
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
                _submitRecord();
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

  void _searchRecord() async {
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
        searchResults = results;
        if (searchResults.isNotEmpty) {
          currentRecord = searchResults.first;
          _populateFields();
        } else {
          errorMessage = 'No results found.';
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to search record: $e';
      });
    }
  }

  void _clearSearch() {
    setState(() {
      searchController.clear();
      searchResults.clear();
      currentSearchIndex = 0;
      _loadFirstRecord();
    });
  }

  void _loadNextSearchResult() {
    if (currentSearchIndex < searchResults.length - 1) {
      setState(() {
        currentSearchIndex++;
        currentRecord = searchResults[currentSearchIndex];
        _populateFields();
      });
    }
  }

  void _loadPreviousSearchResult() {
    if (currentSearchIndex > 0) {
      setState(() {
        currentSearchIndex--;
        currentRecord = searchResults[currentSearchIndex];
        _populateFields();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eco Log Form'),
      ),
      body: isLoading
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
              if (!isNewRecord)
                Center(
                    child: ElevatedButton(
                      onPressed: _createNewRecord,
                      child: Icon(Icons.add),
                    ),
                ),
              if (isNewRecord)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _submitRecord,
                      child: Text('Submit'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _clearFields,
                      child: Text('Clear'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _cancelNewRecord,
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              if (hasUnsavedChanges && !isNewRecord)
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
              labelText: 'Search Record',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: _searchRecord,
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
          onPressed: isNewRecord || hasUnsavedChanges
              ? null
              : () {
            if (hasUnsavedChanges && _hasDataInFields()) {
              _showUnsavedChangesDialog(_loadFirstRecord);
            } else {
              _loadFirstRecord();
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: isNewRecord || hasUnsavedChanges
              ? null
              : currentRecord!.position > 1
              ? () {
            if (hasUnsavedChanges && _hasDataInFields()) {
              _showUnsavedChangesDialog(_loadPreviousRecord);
            } else {
              _loadPreviousRecord();
            }
          }
              : null,
        ),
        Spacer(),
        if (currentRecord != null) Text('${currentRecord!.position} of ${currentRecord!.total}'),
        Spacer(),
        IconButton(
          icon: Icon(Icons.navigate_next),
          onPressed: isNewRecord || hasUnsavedChanges
              ? null
              : () {
            if (hasUnsavedChanges && _hasDataInFields()) {
              _showUnsavedChangesDialog(_loadNextRecord);
            } else {
              _loadNextRecord();
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.last_page),
          onPressed: isNewRecord || hasUnsavedChanges
              ? null
              : () {
            if (hasUnsavedChanges && _hasDataInFields()) {
              _showUnsavedChangesDialog(_loadLastRecord);
            } else {
              _loadLastRecord();
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
            Expanded(child: _buildTextField('NO', noController)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('DESC', descController)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('MODEL', modelController)),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildTextField('ECR', ecrController)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('DATE_LOG', datE_LOGController)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('NAME', nameController)),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildTextField('DATE_REL', datE_RELController)),
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

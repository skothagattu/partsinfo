import 'package:flutter/material.dart';

import '../Services/api_service_parts_sub_log.dart';
import '../models/parts_sub_log.dart';


class PartSubLogFormScreen extends StatefulWidget {
  const PartSubLogFormScreen({super.key});

  @override
  _PartSubLogFormScreenState createState() => _PartSubLogFormScreenState();
}

class _PartSubLogFormScreenState extends State<PartSubLogFormScreen> {
  final ApiService apiService = ApiService();
  PartSubLog? currentLog;
  PartSubLog? originalLog;
  bool isLoading = true;
  String errorMessage = '';
  bool hasUnsavedChanges = false;
  bool isNewLog = false;
  List<PartSubLog> searchResults = [];
  int currentSearchIndex = 0;

  final TextEditingController noController = TextEditingController();
  final TextEditingController partNoController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController reqByController = TextEditingController();
  final TextEditingController reqDateController = TextEditingController();
  final TextEditingController assignController = TextEditingController();
  final TextEditingController acceptController = TextEditingController();
  final TextEditingController rejectController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFirstLog();
  }

  void _populateFields() {
    if (currentLog != null) {
      noController.text = currentLog!.no;
      partNoController.text = currentLog!.parT_NO;
      descController.text = currentLog!.desc;
      reqByController.text = currentLog!.reQ_BY;
      reqDateController.text = currentLog!.reQ_DATE;
      assignController.text = currentLog!.assign;
      acceptController.text = currentLog!.accept;
      rejectController.text = currentLog!.reject;
      dateController.text = currentLog!.date;
      originalLog = currentLog?.copy();
    }
  }

  Future<void> _loadFirstLog() async {
    setState(() {
      isLoading = true;
    });
    try {
      final log = await apiService.fetchFirstLog();
      setState(() {
        currentLog = log;
        _populateFields();
        isLoading = false;
        errorMessage = '';
      });
      print('Loaded first log: ${log.no}');
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load data: $e';
      });
      print('Error: $e');
    }
  }

  Future<void> _loadLastLog() async {
    setState(() {
      isLoading = true;
    });
    try {
      final log = await apiService.fetchLastLog();
      setState(() {
        currentLog = log;
        _populateFields();
        isLoading = false;
        errorMessage = '';
      });
      print('Loaded last log: ${log.no}');
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load data: $e';
      });
      print('Error: $e');
    }
  }

  Future<void> _loadNextLog() async {
    if (hasUnsavedChanges && _hasDataInFields()) {
      _showUnsavedChangesDialog(_loadNextLog);
      return;
    }
    if (currentLog != null) {
      setState(() {
        isLoading = true;
      });
      try {
        final log = await apiService.fetchNextLog(currentLog!.no);
        setState(() {
          currentLog = log;
          _populateFields();
          isLoading = false;
          errorMessage = '';
        });
        print('Loaded next log: ${log.no}');
      } catch (e) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load data: $e';
        });
        print('Error: $e');
      }
    }
  }

  Future<void> _loadPreviousLog() async {
    if (hasUnsavedChanges && _hasDataInFields()) {
      _showUnsavedChangesDialog(_loadPreviousLog);
      return;
    }
    if (currentLog != null && currentLog!.position > 1) {
      setState(() {
        isLoading = true;
      });
      try {
        final log = await apiService.fetchPreviousLog(currentLog!.no);
        setState(() {
          currentLog = log;
          _populateFields();
          isLoading = false;
          errorMessage = '';
        });
        print('Loaded previous log: ${log.no}');
      } catch (e) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load data: $e';
        });
        print('Error: $e');
      }
    }
  }

  void _createNewLog() async {
    if (hasUnsavedChanges && _hasDataInFields()) {
      _showUnsavedChangesDialog(_createNewLog);
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final lastLog = await apiService.fetchLastLog();
      setState(() {
        currentLog = PartSubLog(
          no: '',
          parT_NO: '',
          desc: '',
          reQ_BY: '',
          reQ_DATE: '',
          assign: '',
          accept: '',
          reject: '',
          date: '',
          position: lastLog.total + 1,
          total: lastLog.total + 1,
        );
        _clearFields();
        hasUnsavedChanges = true;
        isNewLog = true;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to create new log: $e';
      });
      print('Error: $e');
    }
  }

  void _clearFields() {
    noController.clear();
    partNoController.clear();
    descController.clear();
    reqByController.clear();
    reqDateController.clear();
    assignController.clear();
    acceptController.clear();
    rejectController.clear();
    dateController.clear();
    setState(() {
      hasUnsavedChanges = false;
      isNewLog = false;
    });
  }

  bool _hasDataInFields() {
    return noController.text.isNotEmpty ||
        partNoController.text.isNotEmpty ||
        descController.text.isNotEmpty ||
        reqByController.text.isNotEmpty ||
        reqDateController.text.isNotEmpty ||
        assignController.text.isNotEmpty ||
        acceptController.text.isNotEmpty ||
        rejectController.text.isNotEmpty ||
        dateController.text.isNotEmpty;
  }

  void _submitLog() async {
    if (!hasUnsavedChanges) return;
    if (noController.text.isEmpty || partNoController.text.isEmpty || descController.text.isEmpty) {
      setState(() {
        errorMessage = 'No, Part No, and Description are required fields.';
      });
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final newLog = PartSubLog(
        no: noController.text,
        parT_NO: partNoController.text,
        desc: descController.text,
        reQ_BY: reqByController.text,
        reQ_DATE: reqDateController.text,
        assign: assignController.text,
        accept: acceptController.text,
        reject: rejectController.text,
        date: dateController.text,
        position: currentLog!.position,
        total: currentLog!.total,
      );

      await apiService.createLog(newLog);
      setState(() {
        isLoading = false;
        errorMessage = '';
        hasUnsavedChanges = false;
        isNewLog = false;
        currentLog = newLog;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorMessageDialog(e.toString());
      print('Error: $e');
    }
  }

  void _submitChanges() async {
    if (!hasUnsavedChanges) return;
    if (currentLog == null) return;

    setState(() {
      isLoading = true;
    });
    try {
      final updatedLog = PartSubLog(
        no: noController.text,
        parT_NO: partNoController.text,
        desc: descController.text,
        reQ_BY: reqByController.text,
        reQ_DATE: reqDateController.text,
        assign: assignController.text,
        accept: acceptController.text,
        reject: rejectController.text,
        date: dateController.text,
        position: currentLog!.position,
        total: currentLog!.total,
      );

      await apiService.updateLog(currentLog!.no, updatedLog);
      setState(() {
        currentLog = updatedLog;
        originalLog = updatedLog.copy();
        isLoading = false;
        errorMessage = '';
        hasUnsavedChanges = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to update log: $e';
      });
      print('Error: $e');
    }
  }

  void _discardChanges() {
    setState(() {
      if (originalLog != null) {
        currentLog = originalLog;
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

  void _cancelNewLog() {
    setState(() {
      _clearFields();
      isNewLog = false;
      hasUnsavedChanges = false;
      _loadFirstLog();
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
                _submitLog();
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

  void _searchLog() async {
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
      final results = await apiService.searchLog(searchController.text);
      setState(() {
        searchResults = results as List<PartSubLog>;
        if (searchResults.isNotEmpty) {
          currentLog = searchResults.first;
          _populateFields();
        } else {
          errorMessage = 'No results found.';
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to search log: $e';
      });
      print('Error: $e');
    }
  }

  void _clearSearch() {
    setState(() {
      searchController.clear();
      searchResults.clear();
      currentSearchIndex = 0;
      _loadFirstLog();
    });
  }

  void _loadNextSearchResult() {
    if (currentSearchIndex < searchResults.length - 1) {
      setState(() {
        currentSearchIndex++;
        currentLog = searchResults[currentSearchIndex];
        _populateFields();
      });
    }
  }

  void _loadPreviousSearchResult() {
    if (currentSearchIndex > 0) {
      setState(() {
        currentSearchIndex--;
        currentLog = searchResults[currentSearchIndex];
        _populateFields();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Part Sub Log Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              SizedBox(height: 20),
              _buildFormFields(),
              SizedBox(height: 20),
              if (!isNewLog)
                ElevatedButton(
                  onPressed: _createNewLog,
                  child: Icon(Icons.add),
                ),
              if (isNewLog)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _submitLog,
                      child: Text('Submit'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _clearFields,
                      child: Text('Clear'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _cancelNewLog,
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              if (hasUnsavedChanges && !isNewLog)
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
              labelText: 'Search Log',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: _searchLog,
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
          onPressed: isNewLog || hasUnsavedChanges
              ? null
              : () {
            if (hasUnsavedChanges && _hasDataInFields()) {
              _showUnsavedChangesDialog(_loadFirstLog);
            } else {
              _loadFirstLog();
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: isNewLog || hasUnsavedChanges
              ? null
              : currentLog!.position > 1
              ? () {
            if (hasUnsavedChanges && _hasDataInFields()) {
              _showUnsavedChangesDialog(_loadPreviousLog);
            } else {
              _loadPreviousLog();
            }
          }
              : null,
        ),
        Spacer(),
        if (currentLog != null) Text('${currentLog!.position} of ${currentLog!.total}'),
        Spacer(),
        IconButton(
          icon: Icon(Icons.navigate_next),
          onPressed: isNewLog || hasUnsavedChanges
              ? null
              : () {
            if (hasUnsavedChanges && _hasDataInFields()) {
              _showUnsavedChangesDialog(_loadNextLog);
            } else {
              _loadNextLog();
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.last_page),
          onPressed: isNewLog || hasUnsavedChanges
              ? null
              : () {
            if (hasUnsavedChanges && _hasDataInFields()) {
              _showUnsavedChangesDialog(_loadLastLog);
            } else {
              _loadLastLog();
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
            Expanded(child: _buildTextField('PART NO', partNoController)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('DESC', descController)),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildTextField('REQ BY', reqByController)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('REQ DATE', reqDateController)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('ASSIGN', assignController)),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildTextField('ACCEPT', acceptController)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('REJECT', rejectController)),
            SizedBox(width: 16),
            Expanded(child: _buildTextField('DATE', dateController)),
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

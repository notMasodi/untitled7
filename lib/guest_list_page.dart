import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:io';

import 'guest_names_view_page.dart';

class GuestListPage extends StatefulWidget {
  @override
  _GuestListPageState createState() => _GuestListPageState();
}

class _GuestListPageState extends State<GuestListPage> {
  List<String> guestNames = [];

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'doc', 'docx'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      _readFile(file);
    }
  }

  void _readFile(PlatformFile file) {
    final input = File(file.path!).readAsBytesSync();
    if (file.extension == 'xlsx' || file.extension == 'xls') {
      var excel = Excel.decodeBytes(input);
      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          setState(() {
            guestNames.add(row.first.toString());
          });
        }
      }
    } else if (file.extension == 'doc' || file.extension == 'docx') {
      // Handle Word document reading here (requires additional package)
      // Example: Use package 'docx' for reading docx files
      // Refer to the documentation of the package you choose to use
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guest List'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Upload'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GuestNamesViewPage(guestNames: guestNames),
                  ),
                );
              },
              child: Text('View'),
            ),
          ],
        ),
      ),
    );
  }
}

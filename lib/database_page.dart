import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'splash_screen.dart';

class DatabasePage extends StatefulWidget {
  @override
  _DatabasePageState createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  List<Map<dynamic, dynamic>> dataList = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String selectedTable = 'table'; // Default table

  @override
  void initState() {
    super.initState();
    _retrieveData(selectedTable);
  }

  void _addData() {
    String name = _nameController.text;
    String age = _ageController.text;

    if (name.isNotEmpty && age.isNotEmpty) {
      _databaseReference.child(selectedTable).push().set({
        'name': name,
        'age': age,
      }).then((_) {
        _nameController.clear();
        _ageController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data added successfully to $selectedTable!')),
        );
        _retrieveData(selectedTable);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add data: $error')),
        );
      });
    }
  }

  void _retrieveData(String table) {
    _databaseReference.child(table).onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          dataList = data.entries.map((e) => {e.key: e.value}).toList();
        });
      }
    });
  }

  void _deleteData(String key) {
    _databaseReference.child('$selectedTable/$key').remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data deleted successfully from $selectedTable!')),
      );
      _retrieveData(selectedTable);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete data: $error')),
      );
    });
  }

  void _editData(String key, String name, String age) {
    _nameController.text = name;
    _ageController.text = age;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Data"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Cancel"),
              onPressed: () {
                _nameController.clear();
                _ageController.clear();
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Save"),
              onPressed: () {
                String newName = _nameController.text;
                String newAge = _ageController.text;

                if (newName.isNotEmpty && newAge.isNotEmpty) {
                  _databaseReference.child('$selectedTable/$key').set({
                    'name': newName,
                    'age': newAge,
                  }).then((_) {
                    _nameController.clear();
                    _ageController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Data updated successfully!')),
                    );
                    _retrieveData(selectedTable);
                    Navigator.of(context).pop();
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update data: $error')),
                    );
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _onTableChanged(String? table) {
    if (table != null) {
      setState(() {
        selectedTable = table;
        dataList.clear(); // Clear the current list
        _retrieveData(selectedTable);
      });
    }
  }

  void _checkExistence() async {
    String name = _nameController.text;
    String age = _ageController.text;

    if (name.isNotEmpty && age.isNotEmpty) {
      final snapshot = await _databaseReference.child(selectedTable).orderByChild('name').equalTo(name).once();
      if (snapshot.snapshot.value != null) {
        final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
        bool exists = false;

        data.forEach((key, value) {
          if (value['age'] == age) {
            exists = true;
          }
        });

        if (exists) {
          Fluttertoast.showToast(
            msg: 'Great',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Wrong',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Wrong',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database Page'),
        backgroundColor: color3,
        actions: [
          DropdownButton<String>(
            value: selectedTable,
            icon: Icon(Icons.arrow_downward),
            onChanged: _onTableChanged,
            items: <String>['table', 'table1']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _addData,
                child: Text('Add Data'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => _retrieveData(selectedTable),
                child: Text('Retrieve Data'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: _checkExistence,
                child: Text('Check Existence'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final entry = dataList[index];
                final key = entry.keys.first;
                final value = entry.values.first as Map<dynamic, dynamic>;
                return ListTile(
                  title: Text('Name: ${value['name']}'),
                  subtitle: Text('Age: ${value['age']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _editData(key, value['name'], value['age']);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteData(key);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

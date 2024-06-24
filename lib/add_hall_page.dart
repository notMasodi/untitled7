import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddHallPage extends StatefulWidget {
  @override
  _AddHallPageState createState() => _AddHallPageState();
}

class _AddHallPageState extends State<AddHallPage> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  String _title = '';
  String _description = '';
  double _rating = 0.0;
  String _imageUrl = '';

  void _addHall() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String hallId = _databaseReference.child('Hall').push().key!;
      _databaseReference.child('Hall/$hallId').set({
        'title': _title,
        'description': _description,
        'rating': _rating,
        'image': _imageUrl,
        'reservations': {}
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hall added successfully')),
        );
        Navigator.of(context).pop();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add hall: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Hall'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Rating'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rating';
                  }
                  final rating = double.tryParse(value);
                  if (rating == null || rating < 0 || rating > 5) {
                    return 'Please enter a valid rating between 0 and 5';
                  }
                  return null;
                },
                onSaved: (value) {
                  _rating = double.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
                onSaved: (value) {
                  _imageUrl = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addHall,
                child: Text('Add Hall'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

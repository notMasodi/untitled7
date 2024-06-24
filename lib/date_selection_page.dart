import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'sub_item_list_page.dart';
import 'user.dart';

class DateSelectionPage extends StatefulWidget {
  final User user;

  DateSelectionPage({required this.user});

  @override
  _DateSelectionPageState createState() => _DateSelectionPageState();
}

class _DateSelectionPageState extends State<DateSelectionPage> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _checkAvailabilityAndReserve(BuildContext context) {
    if (_selectedDate != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SubItemListPage(
            parentTitle: widget.user.name,
            tableName: 'Hall',  // Updated to match your Firebase structure
            selectedDate: _selectedDate,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'Select Date'
                          : DateFormat.yMMMd().format(_selectedDate!),
                      style: TextStyle(fontSize: 18),
                    ),
                    Icon(
                      Icons.calendar_today,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _selectedDate == null ? null : () => _checkAvailabilityAndReserve(context),
            child: Text('Reserve Hall'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

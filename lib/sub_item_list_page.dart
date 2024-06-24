import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'sub_item.dart';
import 'sub_item_detail_page.dart';
import 'package:intl/intl.dart';

class SubItemListPage extends StatefulWidget {
  final String parentTitle;
  final String tableName;
  final DateTime? selectedDate;

  SubItemListPage({required this.parentTitle, required this.tableName, this.selectedDate});

  @override
  _SubItemListPageState createState() => _SubItemListPageState();
}

class _SubItemListPageState extends State<SubItemListPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  List<SubItem> _subItems = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    print('Fetching data for table: ${widget.tableName}');
    _databaseReference.child(widget.tableName).get().then((DataSnapshot snapshot) {
      List<SubItem> subItems = [];
      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          print('Processing entry: $key -> $value');
          if (value != null && value['title'] != null && value['description'] != null && value['rating'] != null && value['image'] != null) {
            final subItem = SubItem(
              id: key, // Add this line
              title: value['title'] as String,
              description: value['description'] as String,
              rating: double.tryParse(value['rating'].toString()) ?? 0.0,
              imageUrl: value['image'] as String,
            );
            if (widget.selectedDate != null) {
              // Check if the hall is available on the selected date
              bool isAvailable = _checkAvailability(value['reservations'], widget.selectedDate!);
              if (isAvailable) {
                subItems.add(subItem);
              } else {
                print('Hall ${subItem.title} is not available on ${widget.selectedDate}');
              }
            } else {
              subItems.add(subItem);
            }
          } else {
            print('Skipping entry with missing fields: $key');
          }
        });
      } else {
        print('No data found for table: ${widget.tableName}');
      }
      // Sort the subItems list by rating in descending order
      subItems.sort((a, b) => b.rating.compareTo(a.rating));
      setState(() {
        _subItems = subItems;
      });
      print('Fetched ${_subItems.length} items');
    }).catchError((error) {
      print('Error fetching data: $error');
    });
  }

  bool _checkAvailability(Map<dynamic, dynamic>? reservations, DateTime selectedDate) {
    if (reservations == null) return true;
    for (var reservation in reservations.values) {
      if (reservation != null && reservation['date'] != null) {
        DateTime reservedDate = DateTime.parse(reservation['date']);
        if (reservedDate.year == selectedDate.year &&
            reservedDate.month == selectedDate.month &&
            reservedDate.day == selectedDate.day) {
          return false; // The hall is reserved for the selected date
        }
      }
    }
    return true; // The hall is available for the selected date
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.parentTitle),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          if (widget.selectedDate != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Selected Date: ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat.yMMMd().format(widget.selectedDate!),
                    style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _subItems.length,
              itemBuilder: (context, index) {
                final subItem = _subItems[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SubItemDetailPage(
                          subItem: subItem,
                          selectedDate: widget.selectedDate!, email: '',
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Image.network(
                            subItem.imageUrl,
                            height: 170,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                subItem.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                subItem.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: List.generate(5, (i) {
                                  return Icon(
                                    i < subItem.rating ? Icons.star : Icons.star_border,
                                    color: Colors.amber,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

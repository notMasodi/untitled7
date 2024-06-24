import 'package:flutter/material.dart';
import 'sub_item_list_page.dart';
import 'user.dart';
import 'date_selection_page.dart';

class RecyclerViewPage extends StatelessWidget {
  final List<User> users = [
    User(name: 'صالات الاعراس', description: 'Hall', rating: 4.9, imageUrl: 'https://www.eventsource.ca/blog/wp-content/uploads/2017/04/NGStudioHeader-1.jpg'),
    User(name: 'المغنيين', description: 'Singer', rating: 4.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbXYb5CJM3orj2d2elwWkSfTP2e8Pk6rg78w&s'),
    User(name: 'الديكور', description: 'Decoration', rating: 3.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpX0rEToQxtSmpRVD_vrdSF_WR_ObPmrmA71-7taJpGvW3MsgtxaZgAEPsf3SfSXsJi14&usqp=CAU'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main RecyclerView'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding
            child: GestureDetector(
              onTap: () {
                if (index == 0) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DateSelectionPage(user: users[index]),
                    ),
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SubItemListPage(
                        parentTitle: users[index].name,
                        tableName: users[index].description,
                      ),
                    ),
                  );
                }
              },
              child: Stack(
                children: [
                  Image.network(
                    users[index].imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Text(
                        users[index].name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

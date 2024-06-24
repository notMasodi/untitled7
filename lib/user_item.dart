import 'package:flutter/material.dart';
import 'user.dart';

class UserItem extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;

  UserItem({required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(user.imageUrl, fit: BoxFit.cover, width: double.infinity, height: 200),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height: 5),
                  Text(
                    user.description,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < user.rating ? Icons.star : Icons.star_border,
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
  }
}

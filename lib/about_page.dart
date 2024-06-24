import 'package:flutter/material.dart';
import 'package:untitled7/splash_screen.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: color3,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'This is the about page.',
            style: TextStyle(fontSize: 24, color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }
}

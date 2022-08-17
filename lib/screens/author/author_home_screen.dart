import 'package:flutter/material.dart';

class AuthorHomeScreen extends StatefulWidget {
  const AuthorHomeScreen({Key? key}) : super(key: key);

  @override
  State<AuthorHomeScreen> createState() => _AuthorHomeScreenState();
}

class _AuthorHomeScreenState extends State<AuthorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(child: Text('author screen')),
    );
  }
}

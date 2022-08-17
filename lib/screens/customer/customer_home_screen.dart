import 'package:flutter/material.dart';
import 'package:project/services/shared_preference.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('customer screen'),
            TextButton(
                onPressed: () {
                  SharedPreference sh = SharedPreference();
                  sh.saveUserdata(false, '', false);
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Logout'))
          ],
        ),
      ),
    );
  }
}

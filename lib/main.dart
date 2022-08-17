import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project/graphql/anonymous_client.dart';
import 'package:project/screens/common/home_screen.dart';
import 'package:project/screens/common/login_screen.dart';
import 'package:project/screens/common/signup_screen.dart';
import 'package:project/screens/common/splash_screen.dart';
import 'package:project/screens/customer/customer_home_screen.dart';

void main() async {
  await initHiveForFlutter();
  runApp(GraphQLProvider(client: anonymousClient, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      title: '',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home_screen': (context) => const HomeScreen(),
        '/customer_home_screen': (context) => const CustomerHomeScreen(),
        '/sign_up': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen()
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project/graphql/authorized_client.dart';
import 'package:project/screens/author/author_home_screen.dart';
import 'package:project/screens/customer/customer_home_screen.dart';
import 'package:project/services/shared_preference.dart';

const String kServerAddress = 'http://192.168.221.240';
Color kThemeColor = Colors.lightBlueAccent;
const kLargeTextStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
const kMediumTextStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.bold);
const kLightMediumTextStyle = TextStyle(
    fontSize: 12, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent);
const kExtraLargeTextStyle = TextStyle(fontSize: 28);

const kLightLargeTextStyle =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white);
const kTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.grey),
  labelStyle: kMediumTextStyle,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

void readUserData(BuildContext context) async {
  SharedPreference sh = SharedPreference();
  bool isLoggedIn = await sh.getLoggedIn() ?? false;
  if (isLoggedIn) {
    bool isAuthor = await sh.getIsAuthor() ?? false;
    String token = await sh.getToken() ?? '';
    if (isAuthor) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: ((context) => GraphQLProvider(
                  client: AuthorizedClient.initailizeClient(token),
                  child: const AuthorHomeScreen()))));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: ((context) => GraphQLProvider(
                  client: AuthorizedClient.initailizeClient(token),
                  child: const CustomerHomeScreen()))));
    }
  } else {
    Navigator.pushReplacementNamed(context, '/home_screen');
  }
}

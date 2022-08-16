import 'package:flutter/material.dart';
import 'package:project/services/shared_preference.dart';

const String serverAddress = 'http://192.168.100.33';

void readUserData(BuildContext context) async {
  SharedPreference sh = SharedPreference();
  bool isLoggedIn = await sh.getLoggedIn() ?? false;
  if (isLoggedIn) {
    bool isAuthor = await sh.getIsAuthor() ?? false;
    // String token = await sh.getToken() ?? '';
    if (isAuthor) {
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: ((context) => GraphQLProvider(
      //             client: Config.initailizeClient(token),
      //             child: const AuthorBottomNav()))));
    } else {
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: ((context) => GraphQLProvider(
      //             client: Config.initailizeClient(token),
      //             child: const CustomerBottomNav()))));
    }
  } else {
    Navigator.pushReplacementNamed(context, '/home_screen');
  }
}

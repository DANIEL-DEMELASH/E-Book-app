import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project/constants/constants.dart';
import 'package:project/graphql/authorized_client.dart';
import 'package:project/graphql/queries.dart';
import 'package:project/screens/author/author_home_screen.dart';
import 'package:project/screens/customer/customer_home_screen.dart';
import 'package:project/services/shared_preference.dart';
import 'package:project/widgets/button_widget.dart';

TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

String token = '';
bool isAuthor = false;
String id = '';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: kThemeColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 100.0, left: 30, right: 30, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: email,
                textAlign: TextAlign.center,
                decoration:
                    kTextFieldDecoration.copyWith(labelText: 'Email address'),
              ),
              const SizedBox(
                height: 25,
              ),
              TextField(
                controller: password,
                textAlign: TextAlign.center,
                obscureText: true,
                decoration:
                    kTextFieldDecoration.copyWith(labelText: 'Password'),
              ),
              const SizedBox(
                height: 25,
              ),
              Mutation(
                  options: MutationOptions(
                      document: login(),
                      onError: (error) {
                        //TODO: display error message
                      },
                      onCompleted: (dynamic resultData) {
                        if (resultData != null) {
                          email.text = '';
                          password.text = '';
                          token = 'Bearer ' + resultData['login']['token'];
                          isAuthor = resultData['login']['isAuthor'];
                          id = resultData['login']['id'];

                          SharedPreference sh = SharedPreference();
                          sh.saveUserdata(
                            true,
                            token,
                            isAuthor,
                            id
                          );

                          if (isAuthor) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => GraphQLProvider(
                                        client:
                                            AuthorizedClient.initailizeClient(
                                                token),
                                        child: const AuthorHomeScreen()))));
                          } else {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GraphQLProvider(
                                        client:
                                            AuthorizedClient.initailizeClient(
                                                token),
                                        child: const CustomerHomeScreen())));
                          }
                        }
                      }),
                  builder: (RunMutation runMutation, QueryResult? result) {
                    return ButtonWidget(
                      color: Colors.lightBlueAccent,
                      text: 'Log in',
                      onPressed: () {
                        runMutation(
                            {"email": email.text, "password": password.text});
                      },
                    );
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                      style: kMediumTextStyle,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/sign_up');
                      },
                      child: Text(
                        'Create Account',
                        style: kMediumTextStyle.copyWith(color: kThemeColor),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

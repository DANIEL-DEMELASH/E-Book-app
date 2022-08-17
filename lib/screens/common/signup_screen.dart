import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project/constants/constants.dart';
import 'package:project/graphql/authorized_client.dart';
import 'package:project/graphql/queries.dart';
import 'package:project/screens/author/author_home_screen.dart';
import 'package:project/screens/customer/customer_home_screen.dart';
import 'package:project/services/shared_preference.dart';
import 'package:project/widgets/button_widget.dart';

TextEditingController firstName = TextEditingController();
TextEditingController lastName = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController confirmPassword = TextEditingController();

String token = '';
bool isAuthor = false;

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isAuthor = false;
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 60.0, 30.0, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstName,
                textAlign: TextAlign.center,
                decoration:
                    kTextFieldDecoration.copyWith(labelText: 'First Name'),
              ),
              const SizedBox(
                height: 25,
              ),
              TextField(
                controller: lastName,
                textAlign: TextAlign.center,
                decoration:
                    kTextFieldDecoration.copyWith(labelText: 'Last Name'),
              ),
              const SizedBox(
                height: 25,
              ),
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
              TextField(
                controller: confirmPassword,
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Confirm password'),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                      value: isAuthor,
                      onChanged: (newValue) {
                        setState(() {
                          isAuthor = !isAuthor;
                        });
                      }),
                  const Text(
                    'i am Author',
                    style: kMediumTextStyle,
                  )
                ],
              ),
              Mutation(
                  options: MutationOptions(
                      document: signup(),
                      onCompleted: (dynamic resultData) {
                        // print(resultData);
                        email.text = '';
                        firstName.text = '';
                        lastName.text = '';
                        password.text = '';
                        confirmPassword.text = '';

                        token = 'Bearer ' + resultData['signup']['token'];
                        isAuthor = resultData['signup']['isAuthor'];

                        SharedPreference sh = SharedPreference();
                        sh.saveUserdata(true, token, isAuthor);

                        //TODO: change redirect pages

                        if (isAuthor) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => GraphQLProvider(
                                      client: AuthorizedClient.initailizeClient(
                                          token),
                                      child: const AuthorHomeScreen()))));
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GraphQLProvider(
                                      client: AuthorizedClient.initailizeClient(
                                          token),
                                      child: const CustomerHomeScreen())));
                        }
                      },
                      onError: (error) {
                        //TODO: print error toast
                      }),
                  builder: (RunMutation runMutation, QueryResult? result) {
                    return ButtonWidget(
                      color: Colors.lightBlueAccent,
                      text: 'Sign up',
                      onPressed: () {
                        runMutation({
                          "first_name": firstName.text,
                          "last_name": lastName.text,
                          "email": email.text,
                          "password": password.text,
                          "isAuthor": false
                        });
                      },
                    );
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Aleady have an account? ',
                      style: kMediumTextStyle,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Login Here',
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

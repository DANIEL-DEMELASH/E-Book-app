import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project/constants/constants.dart';
import 'package:project/graphql/queries.dart';
import 'package:project/models/user.dart';
import 'package:project/services/shared_preference.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({Key? key}) : super(key: key);

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Query(
        options: QueryOptions(
            document: users(), fetchPolicy: FetchPolicy.networkOnly),
        builder: (QueryResult result, {Refetch? refetch, fetchMore}) {
          if (result.hasException) {
            return const Center(
              child: Text('Error'),
            );
          }
          if (result.isLoading) {
            return const Center(
              child: Text('Loading...'),
            );
          }
          List<User> _data = (result.data!['users'] as List)
              .map((e) => User.fromJson(e))
              .toList();

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('assets/images/avator.jpg')),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  _data[0].firstName + ' ' + _data[0].lastName,
                  style: kLargeTextStyle,
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  _data[0].email,
                  style: kLargeTextStyle,
                ),
                const SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    SharedPreference sharedPreference = SharedPreference();
                    sharedPreference.saveUserdata(false, '', false, '');
                    Navigator.pushReplacementNamed(context, '/home_screen');
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                        color: kThemeColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: const Center(
                        child: Text(
                      'Log out',
                      style: kLargeTextStyle,
                    )),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

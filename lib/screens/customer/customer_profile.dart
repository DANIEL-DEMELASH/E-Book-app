import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project/constants/constants.dart';
import 'package:project/graphql/queries.dart';
import 'package:project/models/user.dart';

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
        options: QueryOptions(document: users()),
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

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              Row()
            ],
          );
        },
      ),
    );
  }
}

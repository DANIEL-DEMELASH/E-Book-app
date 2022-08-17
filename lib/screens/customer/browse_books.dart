import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project/constants/constants.dart';
import 'package:project/graphql/queries.dart';
import 'package:project/models/book.dart';
import 'package:project/models/category.dart';
import 'package:project/models/user.dart';
import 'package:project/widgets/basic_widgets.dart';

TextEditingController searchController = TextEditingController();

class BrowseBooks extends StatefulWidget {
  const BrowseBooks({Key? key}) : super(key: key);

  @override
  State<BrowseBooks> createState() => _BrowseBooksState();
}

class _BrowseBooksState extends State<BrowseBooks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: [
          Query(
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

                return SizedBox(
                  height: 250,
                  child: RefreshIndicator(
                      onRefresh: () async => refetch!(),
                      child: userWidget(_data[0], searchController)),
                );
              }),
          Query(
              options: QueryOptions(document: categories()),
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

                List<Category> _data = (result.data!['category'] as List)
                    .map((e) => Category.fromJson(e))
                    .toList();

                return SizedBox(
                  height: 60,
                  child: RefreshIndicator(
                      onRefresh: () async => refetch!(),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _data.length,
                        itemBuilder: (context, index) {
                          return categoryWidget(_data[index]);
                        },
                      )),
                );
              }),
          Query(
              options: QueryOptions(document: books()),
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

                List<Book> _data = (result.data!['books'] as List)
                    .map((e) => Book.fromJson(e))
                    .toList();

                return SizedBox(
                  height: 280,
                  child: RefreshIndicator(
                      onRefresh: () async => refetch!(),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _data.length,
                        itemBuilder: (context, index) {
                          return bookWidget(context, _data[index]);
                        },
                      )),
                );
              }),
          Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: Row(children: const [
                Text(
                  'New arrivals',
                  style: kExtraLargeTextStyle,
                ),
              ])),
          Query(
              options: QueryOptions(document: newBooks()),
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

                List<Book> _data = (result.data!['books'] as List)
                    .map((e) => Book.fromJson(e))
                    .toList();

                return SizedBox(
                  height: 300,
                  child: RefreshIndicator(
                      onRefresh: () async => refetch!(),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _data.length,
                        itemBuilder: (context, index) {
                          return bookWidget(context, _data[index]);
                        },
                      )),
                );
              }),
        ]),
      ),
    );
  }
}

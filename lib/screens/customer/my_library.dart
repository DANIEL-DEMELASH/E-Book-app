import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project/constants/constants.dart';
import 'package:project/graphql/queries.dart';
import 'package:project/services/file_downloader.dart';

class MyLibrary extends StatefulWidget {
  const MyLibrary({Key? key}) : super(key: key);

  @override
  State<MyLibrary> createState() => _MyLibraryState();
}

class _MyLibraryState extends State<MyLibrary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Query(
          options: QueryOptions(
              document: myLibrary(), fetchPolicy: FetchPolicy.networkOnly),
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

            return RefreshIndicator(
                onRefresh: () async => refetch!(),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: result.data!['shopping_session'].length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FileDownloader(
                                        downloadLink: kServerAddress +
                                            ':5000' +
                                            result.data!['shopping_session']
                                                [index]['book']['file'],
                                        fileName:
                                            result.data!['shopping_session']
                                                [index]['book']['title'])));
                          },
                          child: Column(
                            children: [
                              const SizedBox(
                                width: 60,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image(
                                      image: NetworkImage(kServerAddress +
                                          ":5000" +
                                          result.data!['shopping_session']
                                              [index]['book']['cover_photo']),
                                      width: 80.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              Text(
                                result.data!['shopping_session'][index]['book']
                                    ['title'],
                                style: kExtraLargeTextStyle,
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                        )
                      ],
                    );
                  },
                ));
          }),
    );
  }
}

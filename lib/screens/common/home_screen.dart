import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project/constants/constants.dart';
import 'package:project/graphql/queries.dart';
import 'package:project/models/book.dart';
import 'package:project/services/file_downloader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Query(
        options: QueryOptions(
            document: randomBook(), fetchPolicy: FetchPolicy.cacheAndNetwork),
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

          Book book = _data[0];

          // Random random = Random();
          // int randomNumber = random.nextInt(result.data!.length);

          return _data.isEmpty
              ? const Center(
                  child: Text('Book not found'),
                )
              : RefreshIndicator(
                  onRefresh: () async => refetch!(),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image(
                                image: NetworkImage(
                                    kServerAddress + ':5000' + book.coverImage),
                                height: 300,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: RatingBar(
                                ignoreGestures: true,
                                initialRating: double.parse(book.rating),
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                    full: Icon(
                                      Icons.star,
                                      color: kThemeColor,
                                      size: 15,
                                    ),
                                    half: Icon(
                                      Icons.star_half,
                                      color: kThemeColor,
                                      size: 15,
                                    ),
                                    empty: Icon(
                                      Icons.star_outline,
                                      color: kThemeColor,
                                      size: 15,
                                    )),
                                onRatingUpdate: (value) {}),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text(book.title, style: kLargeTextStyle),
                            ),
                          ),
                          Container(
                            height: 60.0,
                            margin: const EdgeInsets.only(top: 30),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FileDownloader(
                                                      downloadLink:
                                                          kServerAddress +
                                                              ':5000' +
                                                              book.sampleFile,
                                                      fileName: book.title +
                                                          '.epub')));
                                    },
                                    child: const Text(
                                      'Read Sample',
                                      style: kLightMediumTextStyle,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/sign_up');
                                    },
                                    child: Text(
                                      'Buy for ' +
                                          book.price.toString() +
                                          ' ETB',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]),
                          ),
                          const Text(
                            'Description',
                            style: kLargeTextStyle,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              book.description,
                              style:
                                  kMediumTextStyle.copyWith(color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/sign_up');
        },
        child: Container(
          height: 60.0,
          decoration: BoxDecoration(
            color: kThemeColor,
          ),
          child: const Center(
            child: Text(
              'Get Started',
              style: kLightLargeTextStyle,
            ),
          ),
        ),
      ),
    );
  }
}

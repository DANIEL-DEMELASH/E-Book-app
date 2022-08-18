import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:localstore/localstore.dart';
import 'package:project/constants/constants.dart';
import 'package:project/graphql/queries.dart';
import 'package:project/models/book.dart';
import 'package:project/screens/customer/book_description.dart';
import 'package:project/screens/customer/cart_screen.dart';

class SearchResult extends StatefulWidget {
  final String title;
  const SearchResult({Key? key, required this.title}) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  final _items = <String, Book>{};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: kThemeColor,
            )),
      ),
      body: Query(
        options: QueryOptions(
            document: searchByTitle(), variables: {"_ilike": widget.title}),
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

          print(_data);

          return _data.isEmpty
              ? const Center(child: Text('Empty'))
              : RefreshIndicator(
                  onRefresh: () async => refetch!(),
                  child: ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BookDescription(
                                            book: _data[index])));
                              },
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Image(
                                    image: NetworkImage(kServerAddress +
                                        ':5000' +
                                        _data[index].coverImage),
                                    height: 200,
                                  ),
                                ),
                                title: Text(_data[index].title),
                                subtitle: Text(_data[index].price.toString()),
                                trailing: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        final id = Localstore.instance
                                            .collection('books')
                                            .doc()
                                            .id;
                                        final item = Book(
                                            title: _data[index].title,
                                            price: _data[index].price,
                                            pageSize: _data[index].pageSize,
                                            edition: _data[index].edition,
                                            coverImage: _data[index].coverImage,
                                            description:
                                                _data[index].description,
                                            id: _data[index].id,
                                            rating: _data[index].rating,
                                            sampleFile:
                                                _data[index].sampleFile);
                                        item.save();
                                        _items.putIfAbsent(item.id, () => item);
                                        double totalPrice = 0;
                                        _items.forEach((key, value) {
                                          totalPrice += value.price;
                                        });
                                        CartScreen.totalPrice = totalPrice;
                                      });
                                      Fluttertoast.showToast(
                                          msg: "book added to the cart",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                              Colors.lightBlueAccent,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    },
                                    child: const Text('Add to Cart')),
                              ),
                            ),
                            const Divider()
                          ],
                        );
                      }),
                );
        },
      ),
    );
  }
}

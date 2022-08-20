import 'dart:async';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:project/constants/constants.dart';
import 'package:project/graphql/queries.dart';
import 'package:project/models/book.dart';
import 'package:project/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  static double totalPrice = 0;
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _db = Localstore.instance;
  final _items = <String, Book>{};

  StreamSubscription<Map<String, dynamic>>? _subscription;

  @override
  void initState() {
    _subscription = _db.collection('books').stream.listen((event) {
      setState(() {
        final item = Book.fromJson(event);
        _items.putIfAbsent(item.id, () => item);
        double totalPrice = 0;
        _items.forEach((key, value) {
          totalPrice += value.price;
        });
        CartScreen.totalPrice = totalPrice;
      });
    });
    if (kIsWeb) _db.collection('books').stream.asBroadcastStream();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 60.0,
        color: Colors.white,
        child: Row(children: <Widget>[
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

                List<User> data = (result.data!['users'] as List)
                    .map((e) => User.fromJson(e))
                    .toList();

                return Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      double totalPrice = 0;
                      _items.forEach((key, value) {
                        totalPrice += value.price;
                      });
                      CartScreen.totalPrice = totalPrice;
                      sendPaymentStatus(data[0]);
                    },
                    child: Container(
                      height: 80.0,
                      margin: const EdgeInsets.only(
                          right: 25.0, top: 5.0, bottom: 5, left: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Text(
                          'Buy for me: ${CartScreen.totalPrice} ETB',
                          style: kMediumTextStyle.copyWith(
                              color: Colors.white, letterSpacing: 1),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ]),
      ),
      body: ListView.builder(
        itemCount: _items.keys.length,
        itemBuilder: (context, index) {
          final key = _items.keys.elementAt(index);
          final item = _items[key]!;
          return Column(
            children: [
              ListTile(
                leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image(
                      image: NetworkImage(
                          kServerAddress + ":5000" + item.coverImage),
                    )),
                title: Text(
                  item.title,
                  style: kLargeTextStyle,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'price ${item.price} ETB',
                    style: kMediumTextStyle,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    setState(() {
                      item.delete();
                      _items.remove(item.id);
                      double totalPrice = 0;
                      _items.forEach((key, value) {
                        totalPrice += value.price;
                      });
                      CartScreen.totalPrice = totalPrice;
                    });
                  },
                ),
              ),
              const Divider()
            ],
          );
        },
      ),
    );
  }

  sendPaymentStatus(user) async {
    String bookId = '';
    _items.forEach((key, value) {
      if (bookId == '') {
        bookId = value.id;
      } else {
        bookId += '~' + value.id;
      }
    });
    try {
      var response =
          await http.post(Uri.parse(kServerAddress + ':5000/pay/order'), body: {
        "user_id": user.id,
        "book_id": bookId,
        "email": user.email,
        "first_name": user.firstName,
        "last_name": user.lastName,
        "total_price": CartScreen.totalPrice.toString()
      });
      // Uri _url = Uri.parse(response.body);
      String _url = response.body;
      _launchInWebViewOrVC(_url);
    } catch (e) {
      print(e);
    }
  }

  // _launchURLBrowser(url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  Future<void> _launchInWebViewOrVC(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'eyob': 'payment'}),
    )) {
      throw 'Could not launch $url';
    }
  }
}

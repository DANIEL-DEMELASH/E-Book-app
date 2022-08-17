import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:project/constants/constants.dart';
import 'package:project/models/book.dart';

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
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 80.0,
                margin: const EdgeInsets.only(
                    left: 25.0, top: 5.0, bottom: 5.0, right: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.lightBlueAccent,
                ),
                child: const Center(
                  child: Text(
                    'Send a Gift',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                _items.forEach((key, value) {
                  CartScreen.totalPrice += value.price;
                });
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
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
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
                            kServerAddress + ":5000" + item.coverImage))),
                title: Text(item.title),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('price ${item.price} ETB'),
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
}

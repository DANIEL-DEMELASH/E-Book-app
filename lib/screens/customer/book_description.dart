import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:localstore/localstore.dart';
import 'package:project/constants/constants.dart';
import 'package:project/models/book.dart';
import 'package:project/screens/customer/cart_screen.dart';
import 'package:project/services/file_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookDescription extends StatefulWidget {
  final Book book;
  const BookDescription({Key? key, required this.book}) : super(key: key);

  @override
  State<BookDescription> createState() => _BookDescriptionState();
}

class _BookDescriptionState extends State<BookDescription> {
  final _items = <String, Book>{};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
            builder: (BuildContext context) => IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                })),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 60.0,
        color: Colors.white,
        child: Row(children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FileDownloader(
                            downloadLink: kServerAddress +
                                ':5000' +
                                widget.book.sampleFile,
                            fileName: widget.book.title + '.epub')));
              },
              child: Container(
                height: 80.0,
                margin: const EdgeInsets.only(
                    left: 25.0, top: 5.0, bottom: 5.0, right: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.lightBlueAccent,
                ),
                child: Center(
                  child: Text(
                    'Read Previews',
                    style: kMediumTextStyle.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          // Mutation(options: MutationOptions(d ocument: ), builder: (RunMutation runMutaion, QueryResult result){}),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  final id = Localstore.instance.collection('books').doc().id;
                  final item = Book(
                    title: widget.book.title,
                    price: widget.book.price,
                    pageSize: widget.book.pageSize,
                    edition: widget.book.edition,
                    coverImage: widget.book.coverImage,
                    description: widget.book.description,
                    id: widget.book.id,
                    rating: widget.book.rating,
                    sampleFile: widget.book.sampleFile,
                  );
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
                    backgroundColor: Colors.lightBlueAccent,
                    textColor: Colors.white,
                    fontSize: 16.0);
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
                    'Add to Cart: ' + widget.book.price.toString() + ' ETB',
                    style: kMediumTextStyle.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image(
                        image: NetworkImage(
                            kServerAddress + ":5000" + widget.book.coverImage),
                        width: 180.0,
                      ),
                    ),
                  ),
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    widget.book.title,
                    style: kExtraLargeTextStyle.copyWith(
                        fontWeight: FontWeight.bold),
                  ),
                )),
                Center(
                    child: Text(
                  'ዶ/ር ምህረት ደበበ',
                  // widget.book.user.firstName + ' ' + widget.book.user.lastName,
                  style: kLargeTextStyle.copyWith(color: Colors.grey),
                )),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RatingBar(
                          ignoreGestures: true,
                          initialRating: double.parse(widget.book.rating),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(widget.book.rating),
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 5.0),
                  child: Text(
                    'Overview',
                    style: kMediumTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 5.0),
                  child: Text(
                    widget.book.description,
                    style: kMediumTextStyle.copyWith(color: Colors.grey),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}

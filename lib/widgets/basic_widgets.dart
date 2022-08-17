import 'package:flutter/material.dart';
import 'package:project/constants/constants.dart';
import 'package:project/screens/customer/book_description.dart';

Widget userWidget(user, controller) {
  return Column(children: [
    Container(
      margin: const EdgeInsets.fromLTRB(20.0, 25.0, 0.0, 0.0),
      child: Row(
        children: <Widget>[
          Text(
            'Welcome ',
            style: kLargeTextStyle.copyWith(color: Colors.grey),
          ),
          Text(user.firstName + ', ' + user.lastName + '! ',
              style: kLargeTextStyle.copyWith(color: Colors.grey)),
        ],
      ),
    ),
    Container(
        margin: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
        child: Row(
          children: const [
            Text(
              'What do you want to\nread today?',
              style: kExtraLargeTextStyle,
            ),
          ],
        )),
    Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
      child: TextField(
        controller: controller,
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          suffixIcon: const Icon(Icons.mic),
          hintText: 'Search',
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    ),
  ]);
}

Widget bookWidget(context, book) {
  return Container(
    margin: const EdgeInsets.all(15.0),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BookDescription(
                            book: book,
                          )));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                image: NetworkImage(kServerAddress + ':5000' + book.coverImage),
                height: 200,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              book.title,
              style: kMediumTextStyle,
            ),
          ),
          Text(
            book.title,
            style: const TextStyle(color: Colors.grey),
          )
        ]),
  );
}

Widget categoryWidget(category) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: Container(
      decoration: BoxDecoration(
          color: kThemeColor,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        category.name,
        style: kMediumTextStyle,
      ),
    ),
  );
}

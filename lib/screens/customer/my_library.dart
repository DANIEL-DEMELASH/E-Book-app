// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:project/graphql/queries.dart';
// import 'package:project/models/book.dart';
// import 'package:project/widgets/basic_widgets.dart';

// class MyLibrary extends StatefulWidget {
//   const MyLibrary({Key? key}) : super(key: key);

//   @override
//   State<MyLibrary> createState() => _MyLibraryState();
// }

// class _MyLibraryState extends State<MyLibrary> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Query(
//           options: QueryOptions(document: myBooks()),
//           builder: (QueryResult result, {Refetch? refetch, fetchMore}) {
//             if (result.hasException) {
//               return const Center(
//                 child: Text('Error'),
//               );
//             }
//             if (result.isLoading) {
//               return const Center(
//                 child: Text('Loading...'),
//               );
//             }

//             List<Book> _data = (result.data!['books'] as List)
//                 .map((e) => Book.fromJson(e))
//                 .toList();

//             return SizedBox(
//               height: 280,
//               child: RefreshIndicator(
//                   onRefresh: () async => refetch!(),
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: _data.length,
//                     itemBuilder: (context, index) {
//                       return bookWidget(context, _data[index]);
//                     },
//                   )),
//             );
//           }),
//     );
//   }
// }

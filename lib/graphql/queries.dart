import 'package:graphql_flutter/graphql_flutter.dart';

books() => gql('''
query{
books {
    title
    ISBN
    description
    cover_photo
    sample_file
    rating
    price
    page_size
    id
    edition
    comment
    category {
      name
      id
    }
    user {
      Author {
        first_name
        last_name
        email
        id
      }
    }
  }
}
  ''');

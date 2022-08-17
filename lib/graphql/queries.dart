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

randomBook() => gql('''query {
  books{
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
  }
}
''');

signup() => gql(
    '''mutation (\$email: String!, \$first_name: String!, \$isAuthor: Boolean!, \$last_name: String!, \$password: String!) {
  signup(email: \$email, first_name: \$first_name, isAuthor: \$isAuthor, last_name: \$last_name, password: \$password) {
    email
    first_name
    id
    isAuthor
    last_name
    token
  }
}
''');

login() => gql('''query (\$email: String!, \$password: String!) {
  login(email: \$email, password: \$password) {
    email
    first_name
    id
    isAuthor
    password
    token
  }
}
''');

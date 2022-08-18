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

users() => gql('''query {
  users {
    first_name
    email
    gender
    id
    last_name
    isAuthor
    password
  }
}
''');

bookByCategory() => gql('''query {
  category {
    id
    name
    book {
      category_id
      cover_photo
      id
      price
      rating
      title
      user {
        Author {
          first_name
          last_name
        }
      }
    }
  }
}
''');

newBooks() => gql('''
  query{
books (order_by: {created_at: desc}, limit: 10) {
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
    
  }
}
''');

categories() => gql('''query {
  category {
    id
    name
  }
}
''');

myBooks() => gql('''query {
  shopping_session {
    book {
      cover_photo
      description
      file
      id
      title
      edition
      page_size
      price
      sample_file
    }
  }
}
''');

searchByTitle() => gql('''query (\$_ilike: String!){
  books(where: {title: {_ilike: \$_ilike}}) {
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
  }
}
''');

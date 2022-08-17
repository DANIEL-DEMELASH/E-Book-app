import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project/constants/constants.dart';

final HttpLink _httpLink = HttpLink(kServerAddress + ':8080/v1/graphql');

ValueNotifier<GraphQLClient> anonymousClient = ValueNotifier<GraphQLClient>(
    GraphQLClient(link: _httpLink, cache: GraphQLCache(store: HiveStore())));

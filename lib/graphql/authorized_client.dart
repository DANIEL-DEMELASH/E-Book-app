import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project/constants/constants.dart';

class AuthorizedClient {
  static final HttpLink httpLink =
      HttpLink(kServerAddress + ':8080/v1/graphql');

  static String _token = '';
  static final AuthLink authLink = AuthLink(getToken: () => _token);

  static final WebSocketLink websocketLink = WebSocketLink(
    kServerAddress + ':8080/v1/graphql',
    config: SocketClientConfig(
      autoReconnect: true,
      inactivityTimeout: const Duration(seconds: 30),
      initialPayload: () async {
        return {
          'headers': {'Authorization': _token},
        };
      },
    ),
  );

  static final Link link = authLink.concat(httpLink).concat(websocketLink);

  static String token = '';
  static ValueNotifier<GraphQLClient> initailizeClient(String token) {
    _token = token;
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(store: HiveStore()),
        link: link,
      ),
    );
    return client;
  }
}

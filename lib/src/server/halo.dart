import 'dart:async';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_orm/angel_orm.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'auth.dart';
import 'authorization_server.dart';

class Halo {
  final QueryExecutor executor;
  final DBCrypt dbCrypt = DBCrypt();
  final String oauth2Path;

  Halo(this.executor, {this.oauth2Path = '/oauth2'});

  HaloAuth _auth;
  HaloAuthorizationServer _authorizationServer;

  HaloAuthorizationServer get authorizationServer => _authorizationServer;

  Future<void> configureServer(Angel app) async {
    // OAuth2 configuration.
    _authorizationServer = HaloAuthorizationServer(executor, dbCrypt);

    // Routes...
    app
      ..post('/login', _auth.postLoginForm)
      ..post('/register', _auth.postRegisterForm)
      ..group(oauth2Path, (router) {
        router
          ..get('/authorize', _authorizationServer.authorizationEndpoint)
          ..post('/token', _authorizationServer.tokenEndpoint);
      });
  }
}

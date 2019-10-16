import 'dart:async';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_halo/angel_halo.dart';
import 'package:angel_oauth2/angel_oauth2.dart';
import 'package:angel_orm/angel_orm.dart';
import 'package:dbcrypt/dbcrypt.dart';

class HaloAuthorizationServer
    extends AuthorizationServer<OAuth2Application, User> {
  final QueryExecutor executor;
  final DBCrypt dbCrypt;

  HaloAuthorizationServer(this.executor, this.dbCrypt);

  /// Finds the [Client] application associated with the given [clientId].
  Future<OAuth2Application> findClient(String clientId) async {
    var id = int.tryParse(clientId);
    if (id == null) {
      throw AngelHttpException.badRequest(message: 'Invalid client ID.');
    }

    var query = OAuth2ApplicationQuery()..where.id.equals(id);
    return await query.getOne(executor);
  }

  bool verifyClient(OAuth2Application client, String clientSecret) {
    var hashed = dbCrypt.hashpw(clientSecret, client.salt);
    return hashed == client.hashedSecretKey;
  }
}

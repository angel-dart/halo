import 'package:angel_migration/angel_migration.dart';
import 'package:angel_model/angel_model.dart';
import 'package:angel_orm/angel_orm.dart';
import 'package:angel_serialize/angel_serialize.dart';
part 'models.g.dart';

@serializable
@orm
class _User extends Model {
  String username, name, email;
  DateTime lastLoginTime;
  String lastLoginIp;

  @Exclude(canDeserialize: true)
  String salt, hashedPassword;

  @ManyToMany(_UserPermission)
  List<_Permission> permissions;
}

@serializable
@orm
class _Permission extends Model {
  String name;
}

@serializable
@orm
class _UserPermission extends Model {
  int userId;
  @belongsTo
  _Permission permission;
}

@serializable
@Orm(tableName: 'oauth2_applications')
class _OAuth2Application extends Model {
  String name, publicKey;

  @Exclude(canDeserialize: true)
  String salt, hashedSecretKey;

  @ManyToMany(_OAuthApplicationScope)
  List<_OAuthScope> scopes;
}

@serializable
@Orm(tableName: 'oauth2_scopes')
class _OAuthScope extends Model {
  String name;
}

@serializable
@Orm(tableName: 'oauth2_application_scopes')
class _OAuthApplicationScope extends Model {
  int applicationId;
  @belongsTo
  _OAuthScope scope;
}

@serializable
@Orm(tableName: 'oauth2_tokens')
class _OAuthToken extends Model {
  @belongsTo
  _OAuth2Application application;
  @belongsTo
  _User user;
}

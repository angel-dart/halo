import 'package:angel_migration/angel_migration.dart';
import 'package:angel_model/angel_model.dart';
import 'package:angel_orm/angel_orm.dart';
import 'package:angel_serialize/angel_serialize.dart';
part 'models.g.dart';

/// The basic migrations required for any Halo-based project.
final List<Migration> haloMigrations = [
  UserMigration(),
  PermissionMigration(),
  UserPermissionMigration(),
  OAuth2ApplicationMigration(),
  OAuth2ScopeMigration(),
  OAuth2ApplicationScopeMigration(),
  OAuth2TokenMigration(),
];

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

  @ManyToMany(_OAuth2ApplicationScope)
  List<_OAuth2Scope> scopes;
}

@serializable
@Orm(tableName: 'oauth2_scopes')
class _OAuth2Scope extends Model {
  String name;
}

@serializable
@Orm(tableName: 'oauth2_application_scopes')
class _OAuth2ApplicationScope extends Model {
  int applicationId;
  @belongsTo
  _OAuth2Scope scope;
}

@serializable
@Orm(tableName: 'oauth2_tokens')
class _OAuth2Token extends Model {
  @belongsTo
  _OAuth2Application application;
  @belongsTo
  _User user;
}

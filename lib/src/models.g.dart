// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class UserMigration extends Migration {
  @override
  up(Schema schema) {
    schema.create('users', (table) {
      table.serial('id')..primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.varChar('username');
      table.varChar('name');
      table.varChar('email');
      table.timeStamp('last_login_time');
      table.varChar('last_login_ip');
      table.varChar('salt');
      table.varChar('hashed_password');
    });
  }

  @override
  down(Schema schema) {
    schema.drop('users', cascade: true);
  }
}

class PermissionMigration extends Migration {
  @override
  up(Schema schema) {
    schema.create('permissions', (table) {
      table.serial('id')..primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.varChar('name');
    });
  }

  @override
  down(Schema schema) {
    schema.drop('permissions');
  }
}

class UserPermissionMigration extends Migration {
  @override
  up(Schema schema) {
    schema.create('user_permissions', (table) {
      table.serial('id')..primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.integer('user_id');
      table
          .declare('permission_id', ColumnType('serial'))
          .references('permissions', 'id');
    });
  }

  @override
  down(Schema schema) {
    schema.drop('user_permissions');
  }
}

class OAuth2ApplicationMigration extends Migration {
  @override
  up(Schema schema) {
    schema.create('oauth2_applications', (table) {
      table.serial('id')..primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.varChar('name');
      table.varChar('public_key');
      table.varChar('salt');
      table.varChar('hashed_secret_key');
    });
  }

  @override
  down(Schema schema) {
    schema.drop('oauth2_applications', cascade: true);
  }
}

class OAuth2ScopeMigration extends Migration {
  @override
  up(Schema schema) {
    schema.create('oauth2_scopes', (table) {
      table.serial('id')..primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.varChar('name');
    });
  }

  @override
  down(Schema schema) {
    schema.drop('oauth2_scopes');
  }
}

class OAuth2ApplicationScopeMigration extends Migration {
  @override
  up(Schema schema) {
    schema.create('oauth2_application_scopes', (table) {
      table.serial('id')..primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.integer('application_id');
      table
          .declare('scope_id', ColumnType('serial'))
          .references('oauth2_scopes', 'id');
    });
  }

  @override
  down(Schema schema) {
    schema.drop('oauth2_application_scopes');
  }
}

class OAuth2TokenMigration extends Migration {
  @override
  up(Schema schema) {
    schema.create('oauth2_tokens', (table) {
      table.serial('id')..primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table
          .declare('application_id', ColumnType('serial'))
          .references('oauth2_applications', 'id');
      table.declare('user_id', ColumnType('serial')).references('users', 'id');
    });
  }

  @override
  down(Schema schema) {
    schema.drop('oauth2_tokens');
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class UserQuery extends Query<User, UserQueryWhere> {
  UserQuery({Query parent, Set<String> trampoline}) : super(parent: parent) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = UserQueryWhere(this);
    leftJoin(
        '(SELECT user_permissions.user_id, permissions.id, permissions.created_at, permissions.updated_at, permissions.name FROM permissions LEFT JOIN user_permissions ON user_permissions.permission_id=permissions.id)',
        'id',
        'user_id',
        additionalFields: const ['id', 'created_at', 'updated_at', 'name'],
        trampoline: trampoline);
  }

  @override
  final UserQueryValues values = UserQueryValues();

  UserQueryWhere _where;

  @override
  get casts {
    return {};
  }

  @override
  get tableName {
    return 'users';
  }

  @override
  get fields {
    return const [
      'id',
      'created_at',
      'updated_at',
      'username',
      'name',
      'email',
      'last_login_time',
      'last_login_ip',
      'salt',
      'hashed_password'
    ];
  }

  @override
  UserQueryWhere get where {
    return _where;
  }

  @override
  UserQueryWhere newWhereClause() {
    return UserQueryWhere(this);
  }

  static User parseRow(List row) {
    if (row.every((x) => x == null)) return null;
    var model = User(
        id: row[0].toString(),
        createdAt: (row[1] as DateTime),
        updatedAt: (row[2] as DateTime),
        username: (row[3] as String),
        name: (row[4] as String),
        email: (row[5] as String),
        lastLoginTime: (row[6] as DateTime),
        lastLoginIp: (row[7] as String),
        salt: (row[8] as String),
        hashedPassword: (row[9] as String));
    if (row.length > 10) {
      model = model.copyWith(
          permissions: [PermissionQuery.parseRow(row.skip(10).take(4).toList())]
              .where((x) => x != null)
              .toList());
    }
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
  }

  @override
  bool canCompile(trampoline) {
    return (!(trampoline.contains('users') &&
        trampoline.contains('user_permissions')));
  }

  @override
  get(QueryExecutor executor) {
    return super.get(executor).then((result) {
      return result.fold<List<User>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
                permissions: List<_Permission>.from(l.permissions ?? [])
                  ..addAll(model.permissions ?? []));
        }
      });
    });
  }

  @override
  update(QueryExecutor executor) {
    return super.update(executor).then((result) {
      return result.fold<List<User>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
                permissions: List<_Permission>.from(l.permissions ?? [])
                  ..addAll(model.permissions ?? []));
        }
      });
    });
  }

  @override
  delete(QueryExecutor executor) {
    return super.delete(executor).then((result) {
      return result.fold<List<User>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
                permissions: List<_Permission>.from(l.permissions ?? [])
                  ..addAll(model.permissions ?? []));
        }
      });
    });
  }
}

class UserQueryWhere extends QueryWhere {
  UserQueryWhere(UserQuery query)
      : id = NumericSqlExpressionBuilder<int>(query, 'id'),
        createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
        username = StringSqlExpressionBuilder(query, 'username'),
        name = StringSqlExpressionBuilder(query, 'name'),
        email = StringSqlExpressionBuilder(query, 'email'),
        lastLoginTime = DateTimeSqlExpressionBuilder(query, 'last_login_time'),
        lastLoginIp = StringSqlExpressionBuilder(query, 'last_login_ip'),
        salt = StringSqlExpressionBuilder(query, 'salt'),
        hashedPassword = StringSqlExpressionBuilder(query, 'hashed_password');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final StringSqlExpressionBuilder username;

  final StringSqlExpressionBuilder name;

  final StringSqlExpressionBuilder email;

  final DateTimeSqlExpressionBuilder lastLoginTime;

  final StringSqlExpressionBuilder lastLoginIp;

  final StringSqlExpressionBuilder salt;

  final StringSqlExpressionBuilder hashedPassword;

  @override
  get expressionBuilders {
    return [
      id,
      createdAt,
      updatedAt,
      username,
      name,
      email,
      lastLoginTime,
      lastLoginIp,
      salt,
      hashedPassword
    ];
  }
}

class UserQueryValues extends MapQueryValues {
  @override
  get casts {
    return {};
  }

  String get id {
    return (values['id'] as String);
  }

  set id(String value) => values['id'] = value;
  DateTime get createdAt {
    return (values['created_at'] as DateTime);
  }

  set createdAt(DateTime value) => values['created_at'] = value;
  DateTime get updatedAt {
    return (values['updated_at'] as DateTime);
  }

  set updatedAt(DateTime value) => values['updated_at'] = value;
  String get username {
    return (values['username'] as String);
  }

  set username(String value) => values['username'] = value;
  String get name {
    return (values['name'] as String);
  }

  set name(String value) => values['name'] = value;
  String get email {
    return (values['email'] as String);
  }

  set email(String value) => values['email'] = value;
  DateTime get lastLoginTime {
    return (values['last_login_time'] as DateTime);
  }

  set lastLoginTime(DateTime value) => values['last_login_time'] = value;
  String get lastLoginIp {
    return (values['last_login_ip'] as String);
  }

  set lastLoginIp(String value) => values['last_login_ip'] = value;
  String get salt {
    return (values['salt'] as String);
  }

  set salt(String value) => values['salt'] = value;
  String get hashedPassword {
    return (values['hashed_password'] as String);
  }

  set hashedPassword(String value) => values['hashed_password'] = value;
  void copyFrom(User model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    username = model.username;
    name = model.name;
    email = model.email;
    lastLoginTime = model.lastLoginTime;
    lastLoginIp = model.lastLoginIp;
    salt = model.salt;
    hashedPassword = model.hashedPassword;
  }
}

class PermissionQuery extends Query<Permission, PermissionQueryWhere> {
  PermissionQuery({Query parent, Set<String> trampoline})
      : super(parent: parent) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = PermissionQueryWhere(this);
  }

  @override
  final PermissionQueryValues values = PermissionQueryValues();

  PermissionQueryWhere _where;

  @override
  get casts {
    return {};
  }

  @override
  get tableName {
    return 'permissions';
  }

  @override
  get fields {
    return const ['id', 'created_at', 'updated_at', 'name'];
  }

  @override
  PermissionQueryWhere get where {
    return _where;
  }

  @override
  PermissionQueryWhere newWhereClause() {
    return PermissionQueryWhere(this);
  }

  static Permission parseRow(List row) {
    if (row.every((x) => x == null)) return null;
    var model = Permission(
        id: row[0].toString(),
        createdAt: (row[1] as DateTime),
        updatedAt: (row[2] as DateTime),
        name: (row[3] as String));
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
  }
}

class PermissionQueryWhere extends QueryWhere {
  PermissionQueryWhere(PermissionQuery query)
      : id = NumericSqlExpressionBuilder<int>(query, 'id'),
        createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
        name = StringSqlExpressionBuilder(query, 'name');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final StringSqlExpressionBuilder name;

  @override
  get expressionBuilders {
    return [id, createdAt, updatedAt, name];
  }
}

class PermissionQueryValues extends MapQueryValues {
  @override
  get casts {
    return {};
  }

  String get id {
    return (values['id'] as String);
  }

  set id(String value) => values['id'] = value;
  DateTime get createdAt {
    return (values['created_at'] as DateTime);
  }

  set createdAt(DateTime value) => values['created_at'] = value;
  DateTime get updatedAt {
    return (values['updated_at'] as DateTime);
  }

  set updatedAt(DateTime value) => values['updated_at'] = value;
  String get name {
    return (values['name'] as String);
  }

  set name(String value) => values['name'] = value;
  void copyFrom(Permission model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    name = model.name;
  }
}

class UserPermissionQuery
    extends Query<UserPermission, UserPermissionQueryWhere> {
  UserPermissionQuery({Query parent, Set<String> trampoline})
      : super(parent: parent) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = UserPermissionQueryWhere(this);
    leftJoin(
        _permission = PermissionQuery(trampoline: trampoline, parent: this),
        'permission_id',
        'id',
        additionalFields: const ['id', 'created_at', 'updated_at', 'name'],
        trampoline: trampoline);
  }

  @override
  final UserPermissionQueryValues values = UserPermissionQueryValues();

  UserPermissionQueryWhere _where;

  PermissionQuery _permission;

  @override
  get casts {
    return {};
  }

  @override
  get tableName {
    return 'user_permissions';
  }

  @override
  get fields {
    return const ['id', 'created_at', 'updated_at', 'user_id', 'permission_id'];
  }

  @override
  UserPermissionQueryWhere get where {
    return _where;
  }

  @override
  UserPermissionQueryWhere newWhereClause() {
    return UserPermissionQueryWhere(this);
  }

  static UserPermission parseRow(List row) {
    if (row.every((x) => x == null)) return null;
    var model = UserPermission(
        id: row[0].toString(),
        createdAt: (row[1] as DateTime),
        updatedAt: (row[2] as DateTime),
        userId: (row[3] as int));
    if (row.length > 5) {
      model = model.copyWith(
          permission: PermissionQuery.parseRow(row.skip(5).take(4).toList()));
    }
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
  }

  PermissionQuery get permission {
    return _permission;
  }
}

class UserPermissionQueryWhere extends QueryWhere {
  UserPermissionQueryWhere(UserPermissionQuery query)
      : id = NumericSqlExpressionBuilder<int>(query, 'id'),
        createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
        userId = NumericSqlExpressionBuilder<int>(query, 'user_id'),
        permissionId = NumericSqlExpressionBuilder<int>(query, 'permission_id');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final NumericSqlExpressionBuilder<int> userId;

  final NumericSqlExpressionBuilder<int> permissionId;

  @override
  get expressionBuilders {
    return [id, createdAt, updatedAt, userId, permissionId];
  }
}

class UserPermissionQueryValues extends MapQueryValues {
  @override
  get casts {
    return {};
  }

  String get id {
    return (values['id'] as String);
  }

  set id(String value) => values['id'] = value;
  DateTime get createdAt {
    return (values['created_at'] as DateTime);
  }

  set createdAt(DateTime value) => values['created_at'] = value;
  DateTime get updatedAt {
    return (values['updated_at'] as DateTime);
  }

  set updatedAt(DateTime value) => values['updated_at'] = value;
  int get userId {
    return (values['user_id'] as int);
  }

  set userId(int value) => values['user_id'] = value;
  int get permissionId {
    return (values['permission_id'] as int);
  }

  set permissionId(int value) => values['permission_id'] = value;
  void copyFrom(UserPermission model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    userId = model.userId;
    if (model.permission != null) {
      values['permission_id'] = model.permission.id;
    }
  }
}

class OAuth2ApplicationQuery
    extends Query<OAuth2Application, OAuth2ApplicationQueryWhere> {
  OAuth2ApplicationQuery({Query parent, Set<String> trampoline})
      : super(parent: parent) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = OAuth2ApplicationQueryWhere(this);
    leftJoin(
        '(SELECT o_auth2_application_scopes.o_auth2_application_id, oauth2_scopes.id, oauth2_scopes.created_at, oauth2_scopes.updated_at, oauth2_scopes.name FROM oauth2_scopes LEFT JOIN o_auth2_application_scopes ON o_auth2_application_scopes.scope_id=oauth2_scopes.id)',
        'id',
        'o_auth2_application_id',
        additionalFields: const ['id', 'created_at', 'updated_at', 'name'],
        trampoline: trampoline);
  }

  @override
  final OAuth2ApplicationQueryValues values = OAuth2ApplicationQueryValues();

  OAuth2ApplicationQueryWhere _where;

  @override
  get casts {
    return {};
  }

  @override
  get tableName {
    return 'oauth2_applications';
  }

  @override
  get fields {
    return const [
      'id',
      'created_at',
      'updated_at',
      'name',
      'public_key',
      'salt',
      'hashed_secret_key'
    ];
  }

  @override
  OAuth2ApplicationQueryWhere get where {
    return _where;
  }

  @override
  OAuth2ApplicationQueryWhere newWhereClause() {
    return OAuth2ApplicationQueryWhere(this);
  }

  static OAuth2Application parseRow(List row) {
    if (row.every((x) => x == null)) return null;
    var model = OAuth2Application(
        id: row[0].toString(),
        createdAt: (row[1] as DateTime),
        updatedAt: (row[2] as DateTime),
        name: (row[3] as String),
        publicKey: (row[4] as String),
        salt: (row[5] as String),
        hashedSecretKey: (row[6] as String));
    if (row.length > 7) {
      model = model.copyWith(
          scopes: [OAuth2ScopeQuery.parseRow(row.skip(7).take(4).toList())]
              .where((x) => x != null)
              .toList());
    }
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
  }

  @override
  bool canCompile(trampoline) {
    return (!(trampoline.contains('oauth2_applications') &&
        trampoline.contains('o_auth2_application_scopes')));
  }

  @override
  get(QueryExecutor executor) {
    return super.get(executor).then((result) {
      return result.fold<List<OAuth2Application>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
                scopes: List<_OAuth2Scope>.from(l.scopes ?? [])
                  ..addAll(model.scopes ?? []));
        }
      });
    });
  }

  @override
  update(QueryExecutor executor) {
    return super.update(executor).then((result) {
      return result.fold<List<OAuth2Application>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
                scopes: List<_OAuth2Scope>.from(l.scopes ?? [])
                  ..addAll(model.scopes ?? []));
        }
      });
    });
  }

  @override
  delete(QueryExecutor executor) {
    return super.delete(executor).then((result) {
      return result.fold<List<OAuth2Application>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
                scopes: List<_OAuth2Scope>.from(l.scopes ?? [])
                  ..addAll(model.scopes ?? []));
        }
      });
    });
  }
}

class OAuth2ApplicationQueryWhere extends QueryWhere {
  OAuth2ApplicationQueryWhere(OAuth2ApplicationQuery query)
      : id = NumericSqlExpressionBuilder<int>(query, 'id'),
        createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
        name = StringSqlExpressionBuilder(query, 'name'),
        publicKey = StringSqlExpressionBuilder(query, 'public_key'),
        salt = StringSqlExpressionBuilder(query, 'salt'),
        hashedSecretKey =
            StringSqlExpressionBuilder(query, 'hashed_secret_key');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final StringSqlExpressionBuilder name;

  final StringSqlExpressionBuilder publicKey;

  final StringSqlExpressionBuilder salt;

  final StringSqlExpressionBuilder hashedSecretKey;

  @override
  get expressionBuilders {
    return [id, createdAt, updatedAt, name, publicKey, salt, hashedSecretKey];
  }
}

class OAuth2ApplicationQueryValues extends MapQueryValues {
  @override
  get casts {
    return {};
  }

  String get id {
    return (values['id'] as String);
  }

  set id(String value) => values['id'] = value;
  DateTime get createdAt {
    return (values['created_at'] as DateTime);
  }

  set createdAt(DateTime value) => values['created_at'] = value;
  DateTime get updatedAt {
    return (values['updated_at'] as DateTime);
  }

  set updatedAt(DateTime value) => values['updated_at'] = value;
  String get name {
    return (values['name'] as String);
  }

  set name(String value) => values['name'] = value;
  String get publicKey {
    return (values['public_key'] as String);
  }

  set publicKey(String value) => values['public_key'] = value;
  String get salt {
    return (values['salt'] as String);
  }

  set salt(String value) => values['salt'] = value;
  String get hashedSecretKey {
    return (values['hashed_secret_key'] as String);
  }

  set hashedSecretKey(String value) => values['hashed_secret_key'] = value;
  void copyFrom(OAuth2Application model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    name = model.name;
    publicKey = model.publicKey;
    salt = model.salt;
    hashedSecretKey = model.hashedSecretKey;
  }
}

class OAuth2ScopeQuery extends Query<OAuth2Scope, OAuth2ScopeQueryWhere> {
  OAuth2ScopeQuery({Query parent, Set<String> trampoline})
      : super(parent: parent) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = OAuth2ScopeQueryWhere(this);
  }

  @override
  final OAuth2ScopeQueryValues values = OAuth2ScopeQueryValues();

  OAuth2ScopeQueryWhere _where;

  @override
  get casts {
    return {};
  }

  @override
  get tableName {
    return 'oauth2_scopes';
  }

  @override
  get fields {
    return const ['id', 'created_at', 'updated_at', 'name'];
  }

  @override
  OAuth2ScopeQueryWhere get where {
    return _where;
  }

  @override
  OAuth2ScopeQueryWhere newWhereClause() {
    return OAuth2ScopeQueryWhere(this);
  }

  static OAuth2Scope parseRow(List row) {
    if (row.every((x) => x == null)) return null;
    var model = OAuth2Scope(
        id: row[0].toString(),
        createdAt: (row[1] as DateTime),
        updatedAt: (row[2] as DateTime),
        name: (row[3] as String));
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
  }
}

class OAuth2ScopeQueryWhere extends QueryWhere {
  OAuth2ScopeQueryWhere(OAuth2ScopeQuery query)
      : id = NumericSqlExpressionBuilder<int>(query, 'id'),
        createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
        name = StringSqlExpressionBuilder(query, 'name');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final StringSqlExpressionBuilder name;

  @override
  get expressionBuilders {
    return [id, createdAt, updatedAt, name];
  }
}

class OAuth2ScopeQueryValues extends MapQueryValues {
  @override
  get casts {
    return {};
  }

  String get id {
    return (values['id'] as String);
  }

  set id(String value) => values['id'] = value;
  DateTime get createdAt {
    return (values['created_at'] as DateTime);
  }

  set createdAt(DateTime value) => values['created_at'] = value;
  DateTime get updatedAt {
    return (values['updated_at'] as DateTime);
  }

  set updatedAt(DateTime value) => values['updated_at'] = value;
  String get name {
    return (values['name'] as String);
  }

  set name(String value) => values['name'] = value;
  void copyFrom(OAuth2Scope model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    name = model.name;
  }
}

class OAuth2ApplicationScopeQuery
    extends Query<OAuth2ApplicationScope, OAuth2ApplicationScopeQueryWhere> {
  OAuth2ApplicationScopeQuery({Query parent, Set<String> trampoline})
      : super(parent: parent) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = OAuth2ApplicationScopeQueryWhere(this);
    leftJoin(_scope = OAuth2ScopeQuery(trampoline: trampoline, parent: this),
        'scope_id', 'id',
        additionalFields: const ['id', 'created_at', 'updated_at', 'name'],
        trampoline: trampoline);
  }

  @override
  final OAuth2ApplicationScopeQueryValues values =
      OAuth2ApplicationScopeQueryValues();

  OAuth2ApplicationScopeQueryWhere _where;

  OAuth2ScopeQuery _scope;

  @override
  get casts {
    return {};
  }

  @override
  get tableName {
    return 'oauth2_application_scopes';
  }

  @override
  get fields {
    return const [
      'id',
      'created_at',
      'updated_at',
      'application_id',
      'scope_id'
    ];
  }

  @override
  OAuth2ApplicationScopeQueryWhere get where {
    return _where;
  }

  @override
  OAuth2ApplicationScopeQueryWhere newWhereClause() {
    return OAuth2ApplicationScopeQueryWhere(this);
  }

  static OAuth2ApplicationScope parseRow(List row) {
    if (row.every((x) => x == null)) return null;
    var model = OAuth2ApplicationScope(
        id: row[0].toString(),
        createdAt: (row[1] as DateTime),
        updatedAt: (row[2] as DateTime),
        applicationId: (row[3] as int));
    if (row.length > 5) {
      model = model.copyWith(
          scope: OAuth2ScopeQuery.parseRow(row.skip(5).take(4).toList()));
    }
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
  }

  OAuth2ScopeQuery get scope {
    return _scope;
  }
}

class OAuth2ApplicationScopeQueryWhere extends QueryWhere {
  OAuth2ApplicationScopeQueryWhere(OAuth2ApplicationScopeQuery query)
      : id = NumericSqlExpressionBuilder<int>(query, 'id'),
        createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
        applicationId =
            NumericSqlExpressionBuilder<int>(query, 'application_id'),
        scopeId = NumericSqlExpressionBuilder<int>(query, 'scope_id');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final NumericSqlExpressionBuilder<int> applicationId;

  final NumericSqlExpressionBuilder<int> scopeId;

  @override
  get expressionBuilders {
    return [id, createdAt, updatedAt, applicationId, scopeId];
  }
}

class OAuth2ApplicationScopeQueryValues extends MapQueryValues {
  @override
  get casts {
    return {};
  }

  String get id {
    return (values['id'] as String);
  }

  set id(String value) => values['id'] = value;
  DateTime get createdAt {
    return (values['created_at'] as DateTime);
  }

  set createdAt(DateTime value) => values['created_at'] = value;
  DateTime get updatedAt {
    return (values['updated_at'] as DateTime);
  }

  set updatedAt(DateTime value) => values['updated_at'] = value;
  int get applicationId {
    return (values['application_id'] as int);
  }

  set applicationId(int value) => values['application_id'] = value;
  int get scopeId {
    return (values['scope_id'] as int);
  }

  set scopeId(int value) => values['scope_id'] = value;
  void copyFrom(OAuth2ApplicationScope model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    applicationId = model.applicationId;
    if (model.scope != null) {
      values['scope_id'] = model.scope.id;
    }
  }
}

class OAuth2TokenQuery extends Query<OAuth2Token, OAuth2TokenQueryWhere> {
  OAuth2TokenQuery({Query parent, Set<String> trampoline})
      : super(parent: parent) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = OAuth2TokenQueryWhere(this);
    leftJoin(
        _application =
            OAuth2ApplicationQuery(trampoline: trampoline, parent: this),
        'application_id',
        'id',
        additionalFields: const [
          'id',
          'created_at',
          'updated_at',
          'name',
          'public_key',
          'salt',
          'hashed_secret_key'
        ],
        trampoline: trampoline);
    leftJoin(_user = UserQuery(trampoline: trampoline, parent: this), 'user_id',
        'id',
        additionalFields: const [
          'id',
          'created_at',
          'updated_at',
          'username',
          'name',
          'email',
          'last_login_time',
          'last_login_ip',
          'salt',
          'hashed_password'
        ],
        trampoline: trampoline);
  }

  @override
  final OAuth2TokenQueryValues values = OAuth2TokenQueryValues();

  OAuth2TokenQueryWhere _where;

  OAuth2ApplicationQuery _application;

  UserQuery _user;

  @override
  get casts {
    return {};
  }

  @override
  get tableName {
    return 'oauth2_tokens';
  }

  @override
  get fields {
    return const [
      'id',
      'created_at',
      'updated_at',
      'application_id',
      'user_id'
    ];
  }

  @override
  OAuth2TokenQueryWhere get where {
    return _where;
  }

  @override
  OAuth2TokenQueryWhere newWhereClause() {
    return OAuth2TokenQueryWhere(this);
  }

  static OAuth2Token parseRow(List row) {
    if (row.every((x) => x == null)) return null;
    var model = OAuth2Token(
        id: row[0].toString(),
        createdAt: (row[1] as DateTime),
        updatedAt: (row[2] as DateTime));
    if (row.length > 5) {
      model = model.copyWith(
          application:
              OAuth2ApplicationQuery.parseRow(row.skip(5).take(7).toList()));
    }
    if (row.length > 12) {
      model = model.copyWith(
          user: UserQuery.parseRow(row.skip(12).take(10).toList()));
    }
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
  }

  OAuth2ApplicationQuery get application {
    return _application;
  }

  UserQuery get user {
    return _user;
  }
}

class OAuth2TokenQueryWhere extends QueryWhere {
  OAuth2TokenQueryWhere(OAuth2TokenQuery query)
      : id = NumericSqlExpressionBuilder<int>(query, 'id'),
        createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
        applicationId =
            NumericSqlExpressionBuilder<int>(query, 'application_id'),
        userId = NumericSqlExpressionBuilder<int>(query, 'user_id');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final NumericSqlExpressionBuilder<int> applicationId;

  final NumericSqlExpressionBuilder<int> userId;

  @override
  get expressionBuilders {
    return [id, createdAt, updatedAt, applicationId, userId];
  }
}

class OAuth2TokenQueryValues extends MapQueryValues {
  @override
  get casts {
    return {};
  }

  String get id {
    return (values['id'] as String);
  }

  set id(String value) => values['id'] = value;
  DateTime get createdAt {
    return (values['created_at'] as DateTime);
  }

  set createdAt(DateTime value) => values['created_at'] = value;
  DateTime get updatedAt {
    return (values['updated_at'] as DateTime);
  }

  set updatedAt(DateTime value) => values['updated_at'] = value;
  int get applicationId {
    return (values['application_id'] as int);
  }

  set applicationId(int value) => values['application_id'] = value;
  int get userId {
    return (values['user_id'] as int);
  }

  set userId(int value) => values['user_id'] = value;
  void copyFrom(OAuth2Token model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    if (model.application != null) {
      values['application_id'] = model.application.id;
    }
    if (model.user != null) {
      values['user_id'] = model.user.id;
    }
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class User extends _User {
  User(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.username,
      this.name,
      this.email,
      this.lastLoginTime,
      this.lastLoginIp,
      this.salt,
      this.hashedPassword,
      List<_Permission> permissions})
      : this.permissions = List.unmodifiable(permissions ?? []);

  /// A unique identifier corresponding to this item.
  @override
  String id;

  /// The time at which this item was created.
  @override
  DateTime createdAt;

  /// The last time at which this item was updated.
  @override
  DateTime updatedAt;

  @override
  String username;

  @override
  String name;

  @override
  String email;

  @override
  DateTime lastLoginTime;

  @override
  String lastLoginIp;

  @override
  String salt;

  @override
  String hashedPassword;

  @override
  List<_Permission> permissions;

  User copyWith(
      {String id,
      DateTime createdAt,
      DateTime updatedAt,
      String username,
      String name,
      String email,
      DateTime lastLoginTime,
      String lastLoginIp,
      String salt,
      String hashedPassword,
      List<_Permission> permissions}) {
    return User(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        username: username ?? this.username,
        name: name ?? this.name,
        email: email ?? this.email,
        lastLoginTime: lastLoginTime ?? this.lastLoginTime,
        lastLoginIp: lastLoginIp ?? this.lastLoginIp,
        salt: salt ?? this.salt,
        hashedPassword: hashedPassword ?? this.hashedPassword,
        permissions: permissions ?? this.permissions);
  }

  bool operator ==(other) {
    return other is _User &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.username == username &&
        other.name == name &&
        other.email == email &&
        other.lastLoginTime == lastLoginTime &&
        other.lastLoginIp == lastLoginIp &&
        other.salt == salt &&
        other.hashedPassword == hashedPassword &&
        ListEquality<_Permission>(DefaultEquality<_Permission>())
            .equals(other.permissions, permissions);
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
      username,
      name,
      email,
      lastLoginTime,
      lastLoginIp,
      salt,
      hashedPassword,
      permissions
    ]);
  }

  @override
  String toString() {
    return "User(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, username=$username, name=$name, email=$email, lastLoginTime=$lastLoginTime, lastLoginIp=$lastLoginIp, salt=$salt, hashedPassword=$hashedPassword, permissions=$permissions)";
  }

  Map<String, dynamic> toJson() {
    return UserSerializer.toMap(this);
  }
}

@generatedSerializable
class Permission extends _Permission {
  Permission({this.id, this.createdAt, this.updatedAt, this.name});

  /// A unique identifier corresponding to this item.
  @override
  String id;

  /// The time at which this item was created.
  @override
  DateTime createdAt;

  /// The last time at which this item was updated.
  @override
  DateTime updatedAt;

  @override
  String name;

  Permission copyWith(
      {String id, DateTime createdAt, DateTime updatedAt, String name}) {
    return Permission(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        name: name ?? this.name);
  }

  bool operator ==(other) {
    return other is _Permission &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.name == name;
  }

  @override
  int get hashCode {
    return hashObjects([id, createdAt, updatedAt, name]);
  }

  @override
  String toString() {
    return "Permission(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, name=$name)";
  }

  Map<String, dynamic> toJson() {
    return PermissionSerializer.toMap(this);
  }
}

@generatedSerializable
class UserPermission extends _UserPermission {
  UserPermission(
      {this.id, this.createdAt, this.updatedAt, this.userId, this.permission});

  /// A unique identifier corresponding to this item.
  @override
  String id;

  /// The time at which this item was created.
  @override
  DateTime createdAt;

  /// The last time at which this item was updated.
  @override
  DateTime updatedAt;

  @override
  int userId;

  @override
  _Permission permission;

  UserPermission copyWith(
      {String id,
      DateTime createdAt,
      DateTime updatedAt,
      int userId,
      _Permission permission}) {
    return UserPermission(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        userId: userId ?? this.userId,
        permission: permission ?? this.permission);
  }

  bool operator ==(other) {
    return other is _UserPermission &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.userId == userId &&
        other.permission == permission;
  }

  @override
  int get hashCode {
    return hashObjects([id, createdAt, updatedAt, userId, permission]);
  }

  @override
  String toString() {
    return "UserPermission(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, userId=$userId, permission=$permission)";
  }

  Map<String, dynamic> toJson() {
    return UserPermissionSerializer.toMap(this);
  }
}

@generatedSerializable
class OAuth2Application extends _OAuth2Application {
  OAuth2Application(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.publicKey,
      this.salt,
      this.hashedSecretKey,
      List<_OAuth2Scope> scopes})
      : this.scopes = List.unmodifiable(scopes ?? []);

  /// A unique identifier corresponding to this item.
  @override
  String id;

  /// The time at which this item was created.
  @override
  DateTime createdAt;

  /// The last time at which this item was updated.
  @override
  DateTime updatedAt;

  @override
  String name;

  @override
  String publicKey;

  @override
  String salt;

  @override
  String hashedSecretKey;

  @override
  List<_OAuth2Scope> scopes;

  OAuth2Application copyWith(
      {String id,
      DateTime createdAt,
      DateTime updatedAt,
      String name,
      String publicKey,
      String salt,
      String hashedSecretKey,
      List<_OAuth2Scope> scopes}) {
    return OAuth2Application(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        name: name ?? this.name,
        publicKey: publicKey ?? this.publicKey,
        salt: salt ?? this.salt,
        hashedSecretKey: hashedSecretKey ?? this.hashedSecretKey,
        scopes: scopes ?? this.scopes);
  }

  bool operator ==(other) {
    return other is _OAuth2Application &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.name == name &&
        other.publicKey == publicKey &&
        other.salt == salt &&
        other.hashedSecretKey == hashedSecretKey &&
        ListEquality<_OAuth2Scope>(DefaultEquality<_OAuth2Scope>())
            .equals(other.scopes, scopes);
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
      name,
      publicKey,
      salt,
      hashedSecretKey,
      scopes
    ]);
  }

  @override
  String toString() {
    return "OAuth2Application(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, name=$name, publicKey=$publicKey, salt=$salt, hashedSecretKey=$hashedSecretKey, scopes=$scopes)";
  }

  Map<String, dynamic> toJson() {
    return OAuth2ApplicationSerializer.toMap(this);
  }
}

@generatedSerializable
class OAuth2Scope extends _OAuth2Scope {
  OAuth2Scope({this.id, this.createdAt, this.updatedAt, this.name});

  /// A unique identifier corresponding to this item.
  @override
  String id;

  /// The time at which this item was created.
  @override
  DateTime createdAt;

  /// The last time at which this item was updated.
  @override
  DateTime updatedAt;

  @override
  String name;

  OAuth2Scope copyWith(
      {String id, DateTime createdAt, DateTime updatedAt, String name}) {
    return OAuth2Scope(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        name: name ?? this.name);
  }

  bool operator ==(other) {
    return other is _OAuth2Scope &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.name == name;
  }

  @override
  int get hashCode {
    return hashObjects([id, createdAt, updatedAt, name]);
  }

  @override
  String toString() {
    return "OAuth2Scope(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, name=$name)";
  }

  Map<String, dynamic> toJson() {
    return OAuth2ScopeSerializer.toMap(this);
  }
}

@generatedSerializable
class OAuth2ApplicationScope extends _OAuth2ApplicationScope {
  OAuth2ApplicationScope(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.applicationId,
      this.scope});

  /// A unique identifier corresponding to this item.
  @override
  String id;

  /// The time at which this item was created.
  @override
  DateTime createdAt;

  /// The last time at which this item was updated.
  @override
  DateTime updatedAt;

  @override
  int applicationId;

  @override
  _OAuth2Scope scope;

  OAuth2ApplicationScope copyWith(
      {String id,
      DateTime createdAt,
      DateTime updatedAt,
      int applicationId,
      _OAuth2Scope scope}) {
    return OAuth2ApplicationScope(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        applicationId: applicationId ?? this.applicationId,
        scope: scope ?? this.scope);
  }

  bool operator ==(other) {
    return other is _OAuth2ApplicationScope &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.applicationId == applicationId &&
        other.scope == scope;
  }

  @override
  int get hashCode {
    return hashObjects([id, createdAt, updatedAt, applicationId, scope]);
  }

  @override
  String toString() {
    return "OAuth2ApplicationScope(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, applicationId=$applicationId, scope=$scope)";
  }

  Map<String, dynamic> toJson() {
    return OAuth2ApplicationScopeSerializer.toMap(this);
  }
}

@generatedSerializable
class OAuth2Token extends _OAuth2Token {
  OAuth2Token(
      {this.id, this.createdAt, this.updatedAt, this.application, this.user});

  /// A unique identifier corresponding to this item.
  @override
  String id;

  /// The time at which this item was created.
  @override
  DateTime createdAt;

  /// The last time at which this item was updated.
  @override
  DateTime updatedAt;

  @override
  _OAuth2Application application;

  @override
  _User user;

  OAuth2Token copyWith(
      {String id,
      DateTime createdAt,
      DateTime updatedAt,
      _OAuth2Application application,
      _User user}) {
    return OAuth2Token(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        application: application ?? this.application,
        user: user ?? this.user);
  }

  bool operator ==(other) {
    return other is _OAuth2Token &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.application == application &&
        other.user == user;
  }

  @override
  int get hashCode {
    return hashObjects([id, createdAt, updatedAt, application, user]);
  }

  @override
  String toString() {
    return "OAuth2Token(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, application=$application, user=$user)";
  }

  Map<String, dynamic> toJson() {
    return OAuth2TokenSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const UserSerializer userSerializer = UserSerializer();

class UserEncoder extends Converter<User, Map> {
  const UserEncoder();

  @override
  Map convert(User model) => UserSerializer.toMap(model);
}

class UserDecoder extends Converter<Map, User> {
  const UserDecoder();

  @override
  User convert(Map map) => UserSerializer.fromMap(map);
}

class UserSerializer extends Codec<User, Map> {
  const UserSerializer();

  @override
  get encoder => const UserEncoder();
  @override
  get decoder => const UserDecoder();
  static User fromMap(Map map) {
    return User(
        id: map['id'] as String,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null,
        username: map['username'] as String,
        name: map['name'] as String,
        email: map['email'] as String,
        lastLoginTime: map['last_login_time'] != null
            ? (map['last_login_time'] is DateTime
                ? (map['last_login_time'] as DateTime)
                : DateTime.parse(map['last_login_time'].toString()))
            : null,
        lastLoginIp: map['last_login_ip'] as String,
        salt: map['salt'] as String,
        hashedPassword: map['hashed_password'] as String,
        permissions: map['permissions'] is Iterable
            ? List.unmodifiable(
                ((map['permissions'] as Iterable).whereType<Map>())
                    .map(PermissionSerializer.fromMap))
            : null);
  }

  static Map<String, dynamic> toMap(_User model) {
    if (model == null) {
      return null;
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'username': model.username,
      'name': model.name,
      'email': model.email,
      'last_login_time': model.lastLoginTime?.toIso8601String(),
      'last_login_ip': model.lastLoginIp,
      'permissions':
          model.permissions?.map((m) => PermissionSerializer.toMap(m))?.toList()
    };
  }
}

abstract class UserFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    username,
    name,
    email,
    lastLoginTime,
    lastLoginIp,
    salt,
    hashedPassword,
    permissions
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String username = 'username';

  static const String name = 'name';

  static const String email = 'email';

  static const String lastLoginTime = 'last_login_time';

  static const String lastLoginIp = 'last_login_ip';

  static const String salt = 'salt';

  static const String hashedPassword = 'hashed_password';

  static const String permissions = 'permissions';
}

const PermissionSerializer permissionSerializer = PermissionSerializer();

class PermissionEncoder extends Converter<Permission, Map> {
  const PermissionEncoder();

  @override
  Map convert(Permission model) => PermissionSerializer.toMap(model);
}

class PermissionDecoder extends Converter<Map, Permission> {
  const PermissionDecoder();

  @override
  Permission convert(Map map) => PermissionSerializer.fromMap(map);
}

class PermissionSerializer extends Codec<Permission, Map> {
  const PermissionSerializer();

  @override
  get encoder => const PermissionEncoder();
  @override
  get decoder => const PermissionDecoder();
  static Permission fromMap(Map map) {
    return Permission(
        id: map['id'] as String,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null,
        name: map['name'] as String);
  }

  static Map<String, dynamic> toMap(_Permission model) {
    if (model == null) {
      return null;
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'name': model.name
    };
  }
}

abstract class PermissionFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    name
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String name = 'name';
}

const UserPermissionSerializer userPermissionSerializer =
    UserPermissionSerializer();

class UserPermissionEncoder extends Converter<UserPermission, Map> {
  const UserPermissionEncoder();

  @override
  Map convert(UserPermission model) => UserPermissionSerializer.toMap(model);
}

class UserPermissionDecoder extends Converter<Map, UserPermission> {
  const UserPermissionDecoder();

  @override
  UserPermission convert(Map map) => UserPermissionSerializer.fromMap(map);
}

class UserPermissionSerializer extends Codec<UserPermission, Map> {
  const UserPermissionSerializer();

  @override
  get encoder => const UserPermissionEncoder();
  @override
  get decoder => const UserPermissionDecoder();
  static UserPermission fromMap(Map map) {
    return UserPermission(
        id: map['id'] as String,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null,
        userId: map['user_id'] as int,
        permission: map['permission'] != null
            ? PermissionSerializer.fromMap(map['permission'] as Map)
            : null);
  }

  static Map<String, dynamic> toMap(_UserPermission model) {
    if (model == null) {
      return null;
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'user_id': model.userId,
      'permission': PermissionSerializer.toMap(model.permission)
    };
  }
}

abstract class UserPermissionFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    userId,
    permission
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String userId = 'user_id';

  static const String permission = 'permission';
}

const OAuth2ApplicationSerializer oAuth2ApplicationSerializer =
    OAuth2ApplicationSerializer();

class OAuth2ApplicationEncoder extends Converter<OAuth2Application, Map> {
  const OAuth2ApplicationEncoder();

  @override
  Map convert(OAuth2Application model) =>
      OAuth2ApplicationSerializer.toMap(model);
}

class OAuth2ApplicationDecoder extends Converter<Map, OAuth2Application> {
  const OAuth2ApplicationDecoder();

  @override
  OAuth2Application convert(Map map) =>
      OAuth2ApplicationSerializer.fromMap(map);
}

class OAuth2ApplicationSerializer extends Codec<OAuth2Application, Map> {
  const OAuth2ApplicationSerializer();

  @override
  get encoder => const OAuth2ApplicationEncoder();
  @override
  get decoder => const OAuth2ApplicationDecoder();
  static OAuth2Application fromMap(Map map) {
    return OAuth2Application(
        id: map['id'] as String,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null,
        name: map['name'] as String,
        publicKey: map['public_key'] as String,
        salt: map['salt'] as String,
        hashedSecretKey: map['hashed_secret_key'] as String,
        scopes: map['scopes'] is Iterable
            ? List.unmodifiable(((map['scopes'] as Iterable).whereType<Map>())
                .map(OAuth2ScopeSerializer.fromMap))
            : null);
  }

  static Map<String, dynamic> toMap(_OAuth2Application model) {
    if (model == null) {
      return null;
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'name': model.name,
      'public_key': model.publicKey,
      'scopes':
          model.scopes?.map((m) => OAuth2ScopeSerializer.toMap(m))?.toList()
    };
  }
}

abstract class OAuth2ApplicationFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    name,
    publicKey,
    salt,
    hashedSecretKey,
    scopes
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String name = 'name';

  static const String publicKey = 'public_key';

  static const String salt = 'salt';

  static const String hashedSecretKey = 'hashed_secret_key';

  static const String scopes = 'scopes';
}

const OAuth2ScopeSerializer oAuth2ScopeSerializer = OAuth2ScopeSerializer();

class OAuth2ScopeEncoder extends Converter<OAuth2Scope, Map> {
  const OAuth2ScopeEncoder();

  @override
  Map convert(OAuth2Scope model) => OAuth2ScopeSerializer.toMap(model);
}

class OAuth2ScopeDecoder extends Converter<Map, OAuth2Scope> {
  const OAuth2ScopeDecoder();

  @override
  OAuth2Scope convert(Map map) => OAuth2ScopeSerializer.fromMap(map);
}

class OAuth2ScopeSerializer extends Codec<OAuth2Scope, Map> {
  const OAuth2ScopeSerializer();

  @override
  get encoder => const OAuth2ScopeEncoder();
  @override
  get decoder => const OAuth2ScopeDecoder();
  static OAuth2Scope fromMap(Map map) {
    return OAuth2Scope(
        id: map['id'] as String,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null,
        name: map['name'] as String);
  }

  static Map<String, dynamic> toMap(_OAuth2Scope model) {
    if (model == null) {
      return null;
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'name': model.name
    };
  }
}

abstract class OAuth2ScopeFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    name
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String name = 'name';
}

const OAuth2ApplicationScopeSerializer oAuth2ApplicationScopeSerializer =
    OAuth2ApplicationScopeSerializer();

class OAuth2ApplicationScopeEncoder
    extends Converter<OAuth2ApplicationScope, Map> {
  const OAuth2ApplicationScopeEncoder();

  @override
  Map convert(OAuth2ApplicationScope model) =>
      OAuth2ApplicationScopeSerializer.toMap(model);
}

class OAuth2ApplicationScopeDecoder
    extends Converter<Map, OAuth2ApplicationScope> {
  const OAuth2ApplicationScopeDecoder();

  @override
  OAuth2ApplicationScope convert(Map map) =>
      OAuth2ApplicationScopeSerializer.fromMap(map);
}

class OAuth2ApplicationScopeSerializer
    extends Codec<OAuth2ApplicationScope, Map> {
  const OAuth2ApplicationScopeSerializer();

  @override
  get encoder => const OAuth2ApplicationScopeEncoder();
  @override
  get decoder => const OAuth2ApplicationScopeDecoder();
  static OAuth2ApplicationScope fromMap(Map map) {
    return OAuth2ApplicationScope(
        id: map['id'] as String,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null,
        applicationId: map['application_id'] as int,
        scope: map['scope'] != null
            ? OAuth2ScopeSerializer.fromMap(map['scope'] as Map)
            : null);
  }

  static Map<String, dynamic> toMap(_OAuth2ApplicationScope model) {
    if (model == null) {
      return null;
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'application_id': model.applicationId,
      'scope': OAuth2ScopeSerializer.toMap(model.scope)
    };
  }
}

abstract class OAuth2ApplicationScopeFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    applicationId,
    scope
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String applicationId = 'application_id';

  static const String scope = 'scope';
}

const OAuth2TokenSerializer oAuth2TokenSerializer = OAuth2TokenSerializer();

class OAuth2TokenEncoder extends Converter<OAuth2Token, Map> {
  const OAuth2TokenEncoder();

  @override
  Map convert(OAuth2Token model) => OAuth2TokenSerializer.toMap(model);
}

class OAuth2TokenDecoder extends Converter<Map, OAuth2Token> {
  const OAuth2TokenDecoder();

  @override
  OAuth2Token convert(Map map) => OAuth2TokenSerializer.fromMap(map);
}

class OAuth2TokenSerializer extends Codec<OAuth2Token, Map> {
  const OAuth2TokenSerializer();

  @override
  get encoder => const OAuth2TokenEncoder();
  @override
  get decoder => const OAuth2TokenDecoder();
  static OAuth2Token fromMap(Map map) {
    return OAuth2Token(
        id: map['id'] as String,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null,
        application: map['application'] != null
            ? OAuth2ApplicationSerializer.fromMap(map['application'] as Map)
            : null,
        user: map['user'] != null
            ? UserSerializer.fromMap(map['user'] as Map)
            : null);
  }

  static Map<String, dynamic> toMap(_OAuth2Token model) {
    if (model == null) {
      return null;
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'application': OAuth2ApplicationSerializer.toMap(model.application),
      'user': UserSerializer.toMap(model.user)
    };
  }
}

abstract class OAuth2TokenFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    application,
    user
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String application = 'application';

  static const String user = 'user';
}

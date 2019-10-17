import 'dart:async';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_orm/angel_orm.dart';
import 'package:angel_validate/angel_validate.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:angel_halo/angel_halo.dart';

// TODO: Brute-force protection
class HaloAuth {
  final QueryExecutor executor;
  final DBCrypt dbCrypt;

  var _emailField = TextField('email').match([isEmail]);
  var _nameField = TextField('name');
  var _passwordField = TextField('password');
  var _confirmPasswordField =
      TextField('password', confirmedAs: 'confirm_password')
          .match([minLength(8), maxLength(128)]);

  HaloAuth(this.executor, this.dbCrypt);

  Future<void> postLoginForm(RequestContext req, ResponseContext res) async {
    // TODO: If the user is logged in, send them elsewhere.
    // Read the response body.
    var email = await _emailField.getValue(req).then((s) => s.toLowerCase());
    var password = await _passwordField.getValue(req);
    return await executor.transaction((tx) async {
      var query = UserQuery()..where.email.equals(email);
      var user = await query.getOne(tx);
      if (user == null) {
        throw AngelHttpException.forbidden(
            message: 'No user with that email exists.');
      }

      var now = DateTime.now();
      var hashed = dbCrypt.hashpw(password, user.salt);
      if (hashed != user.hashedPassword) {
        // TODO: Keep track of failed attempts, potentially lock account
        throw AngelHttpException.notAuthenticated(message: 'Invalid password.');
      } else {
        // Update the user.
        // TODO: Get real IP if using nginx
        var query = UserQuery()..where.id.equals(user.idAsInt);
        query.values
          ..lastLoginIp = req.ip
          ..lastLoginTime = now
          ..createdAt = now;

        // TODO: Redirect the user.
        return await query.updateOne(tx);
      }
    });
  }

  Future<void> postRegisterForm(RequestContext req, ResponseContext res) async {
    // Read the response body.
    var email = await _emailField.getValue(req).then((s) => s.toLowerCase());
    var name = await _nameField.getValue(req);
    var password = await _confirmPasswordField.getValue(req);
    return await executor.transaction((tx) async {
      // Make sure no such user exists.
      var existingQuery = UserQuery()..where.email.equals(email);
      var existing = await existingQuery.getOne(tx);
      if (existing != null) {
        throw AngelHttpException.forbidden(
            message: 'A user with that email already exists.');
      }

      // Insert a new user.
      var now = DateTime.now();
      var salt = dbCrypt.gensalt();
      var query = UserQuery();
      query.values
        ..email = email
        ..name = name
        ..salt = salt
        ..hashedPassword = dbCrypt.hashpw(password, salt)
        ..createdAt = now
        ..updatedAt = now;

      // TODO: Create a token...
      var user = await query.insert(tx);
      return user;
    });
  }
}

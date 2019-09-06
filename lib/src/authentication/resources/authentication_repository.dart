import 'package:bus_tracker_client/src/authentication/blocs/authentication_provider.dart';
import 'package:bus_tracker_client/src/authentication/models/create_user.dart';
import 'package:bus_tracker_client/src/authentication/models/user_response.dart';
import 'package:inject/inject.dart';

class AuthenticationRepository {
  AuthenticationProvider _authenticationProvider;

  @provide
  AuthenticationRepository(this._authenticationProvider);

  Future<UserResponse> createUser(CreateUser createUser) async =>
      await _authenticationProvider.createUser(createUser);

  Future<UserResponse> readUser(String name) async =>
      await _authenticationProvider.readUser(name);
}

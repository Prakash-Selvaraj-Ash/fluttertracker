import 'package:bus_tracker_client/src/authentication/models/create_user.dart';
import 'package:bus_tracker_client/src/authentication/models/user_response.dart';
import 'package:bus_tracker_client/src/authentication/webclient/authentication_client.dart';
import 'package:inject/inject.dart';

class AuthenticationProvider {
  AuthenticationClient _authenticationClient;

  @provide
  AuthenticationProvider(this._authenticationClient);

  Future<UserResponse> createUser(CreateUser createUser) async =>
      await _authenticationClient.createUser(createUser);

  Future<UserResponse> readUser(String name) async =>
      await _authenticationClient.readUser(name);
}

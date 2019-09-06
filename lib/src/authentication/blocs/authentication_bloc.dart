import 'package:bus_tracker_client/src/authentication/models/create_user.dart';
import 'package:bus_tracker_client/src/authentication/models/user_response.dart';
import 'package:bus_tracker_client/src/authentication/resources/authentication_repository.dart';
import 'package:bus_tracker_client/src/blocs/bloc_base.dart';
import 'package:inject/inject.dart';

class AuthenticationBloc extends BlocBase {
  AuthenticationRepository _authenticationRepository;

  @provide
  AuthenticationBloc(this._authenticationRepository);

  Future<UserResponse> createUser(CreateUser createUser) async =>
      await _authenticationRepository.createUser(createUser);

  Future<UserResponse> getUser(String name) async =>
      await _authenticationRepository.readUser(name);

  @override
  void dispose() {}
}

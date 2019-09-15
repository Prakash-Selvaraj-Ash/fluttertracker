import 'dart:convert';

import 'package:bus_tracker_client/src/authentication/models/create_user.dart';
import 'package:bus_tracker_client/src/authentication/models/user_response.dart';
import 'package:bus_tracker_client/src/webclient/web_client_base.dart';
import 'package:http/http.dart';
import 'package:inject/inject.dart';

class AuthenticationClient extends WebClientBase {
  Client _httpClient;
  final String routePrefix = "students";

  @provide
  AuthenticationClient(this._httpClient);

  Future<UserResponse> createUser(CreateUser createUser) async {
    Map<String, dynamic> jsonBody = createUser.toJson();
    Map<String, String> _headers = Map<String, String>();
    _headers['Content-Type'] = 'application/json; charset=utf-8';
    Response response = await this._httpClient.post("${baseUrl}/${routePrefix}",
        body: json.encode(jsonBody), headers: _headers);
    if (response.statusCode == 200) {
      dynamic createdStudent = json.decode(response.body);
      return UserResponse.fromJson(createdStudent);
    } else {
      return null;
    }
  }

  Future<UserResponse> readUser(String name) async {
    Response response = await this
        ._httpClient
        .get("${baseUrl}/${routePrefix}/byname?name=${name}");
    if (response.statusCode == 200) {
      dynamic student = json.decode(response.body);
      return UserResponse.fromJson(student);
    } else {
      return null;
    }
  }
}

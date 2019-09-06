import 'dart:convert';
import 'package:http/http.dart' show Client, Response;
import 'http_method.dart';
import 'package:inject/inject.dart';

class WebRequestBuilder<T> {
  Client _httpClient;
  HttpMethod _method;
  String _urlPattern;
  String _bodyJson;
  Map<String, String> _parameters;
  Map<String, String> _headers;

  @provide
  WebRequestBuilder(this._httpClient) {
    _parameters = Map<String, String>();
    _headers = Map<String, String>();
    _headers['Content-Type'] = 'application/json';
  }

  WebRequestBuilder create<T>(HttpMethod method, String urlPattern) {
    this._method = method;
    this._urlPattern = urlPattern;
    return this;
  }

  WebRequestBuilder withBodyString(String bodyString) {
    this._bodyJson = bodyString;
    return this;
  }

  WebRequestBuilder withParameters(String key, String value) {
    _parameters[key] = value;
    return this;
  }

  WebRequestBuilder withHeaders(String key, String value) {
    _headers[key] = value;
    return this;
  }

  Future<dynamic> executeRequestAsync() async {
    String finalUrl = this._urlPattern;
    this
        ._parameters
        .forEach((k, v) => finalUrl = finalUrl.replaceAll('{$k}', v));

    switch (_method) {
      case HttpMethod.Get:
        Response response = await _httpClient.get(finalUrl);
        return jsonDecode(response.body);
        
      case HttpMethod.Post:
        Response response =
            await _httpClient.post(finalUrl, headers: _headers, body: _bodyJson);
        return jsonDecode(response.body);

      case HttpMethod.Put:
        Response response =
            await _httpClient.put(finalUrl, headers: _headers, body: _bodyJson);
        return jsonDecode(response.body);  
        
      default:
        return null;
    }
  }
}

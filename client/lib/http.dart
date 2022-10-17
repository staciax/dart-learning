import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'errors.dart';

// http client inspired by https://github.com/Rapptz/discord.py

Map _toJson(http.Response response) {
  // convert response to json
  var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  return decodedResponse;
}

class Route {
  Route({required this.method, required this.path, this.params});

  String method;
  String path;
  Map<String, String>? params;
  final _url = 'reqbin.com'; // example url

  Uri uri() {
    return Uri.https(_url, path, params);
  }
}

class HTTPClient {
  final _client = http.Client();
  final _headers = {'Content-Type': 'application/json'};

  Future<Object?> requests(Route route, Object? body) async {
    var method = route.method;
    var uri = route.uri();
    for (int tries = 0; tries < 5; tries++) {
      try {
        http.Response response;

        // method switch
        if (method == 'GET') {
          response = await _client.get(uri, headers: _headers);
        } else if (method.toUpperCase() == 'POST') {
          response = await _client.post(uri, headers: _headers, body: body);
        } else if (method.toUpperCase() == 'PUT') {
          response = await _client.put(uri, headers: _headers, body: body);
        } else if (method.toUpperCase() == 'PATCH') {
          response = await _client.patch(uri, headers: _headers, body: body);
        } else if (method.toUpperCase() == 'DELETE') {
          response = await _client.delete(uri, headers: _headers, body: body);
        } else if (method.toUpperCase() == 'HEAD') {
          response = await _client.head(uri, headers: _headers);
        } else {
          throw Exception('Invalid Method');
        }

        // status handling
        if (response.statusCode >= 200) {
          return _toJson(response); // return json
        } else if (response.statusCode == 400) {
          throw BadRequest('Bad Request');
        } else if (response.statusCode == 401) {
          throw Unauthorized('Unauthorized');
        } else if (response.statusCode == 403) {
          throw Forbidden('Forbidden');
        } else if (response.statusCode == 404) {
          throw NotFound('Not Found');
        } else if (response.statusCode == 429) {
          throw TooManyRequests('Too Many Requests');
        } else if ({500, 502, 503, 524}.contains(response.statusCode)) {
          Future.delayed(const Duration(seconds: 5));
          continue;
        } else if (response.statusCode >= 500) {
          throw InternalServerError('Server Error');
        } else {
          throw Exception('Unknown Error');
        }
      } catch (e) {
        if (tries < 4) {
          Future.delayed(const Duration(seconds: 2)); // wait 2 seconds
          continue; // try again
        } else {
          throw Exception('HTTP Error');
        }
      }
    }
    return null; // return null if error
  }

  void close() {
    _client.close();
  }

  Future<Object?> fetchExample() {
    final r = Route(method: 'GET', path: '/echo/get/json');
    return requests(r, {});
  }
}

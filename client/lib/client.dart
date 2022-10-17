import 'http.dart';

class Client {
  final _http = HTTPClient();

  Future<Object?> fetchExample() async {
    return await _http.fetchExample();
  }

  void close() {
    // close http client
    _http.close();
  }
}

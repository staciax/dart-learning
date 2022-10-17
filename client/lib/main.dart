import 'client.dart';

Future<void> main() async {
  // create client
  final client = Client();

  // try to fetch example
  final example = await client.fetchExample();
  print(example);

  // close the client
  client.close();
}

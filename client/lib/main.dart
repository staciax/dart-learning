import 'client.dart';
import 'package:logging/logging.dart';

Future<void> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  // create client
  final client = Client();

  // try to fetch example
  final example = await client.fetchExample();
  print(example);

  // close the client
  client.close();
}

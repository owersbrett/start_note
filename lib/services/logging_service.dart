import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

class LoggingService {
  static final Logger logger = Logger('logz');

  static Future<String> initialize() async {
    hierarchicalLoggingEnabled = true;
    logger.level = Level.INFO;
    return const Uuid().v4();
  }
}

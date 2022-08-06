import 'package:notime/services/date_service.dart';
import 'package:test/scaffolding.dart';

void main() {
  test("Date Time To String", () {
    final String now = DateService.dateTimeToString(DateTime.now());
    print(now);
  });
}

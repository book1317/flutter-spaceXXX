import 'package:intl/intl.dart';

convertUtcStringToFormatDate(String utcString) {
  String formatedDate = '-';

  if (utcString != '') {
    DateTime launchedDateTime =
        DateFormat('yyyy-MM-ddTHH:mm:sssZ').parseUtc(utcString);
    formatedDate = DateFormat.yMMMMd('en_US').format(launchedDateTime);
  }

  return formatedDate;
}

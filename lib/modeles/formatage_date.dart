import 'package:intl/intl.dart';

class FormatageDate {
  String formatted(int timeStamp) {
    DateTime postTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    DateTime now = DateTime.now();
    DateFormat format;

    if (now.difference(postTime).inDays > 0) {
      format = DateFormat.yMMMEd(); // Exemple : Tue, Apr 9, 2025
    } else {
      format = DateFormat.Hm(); // Exemple : 15:42
    }

    return format.format(postTime).toString();
  }
}

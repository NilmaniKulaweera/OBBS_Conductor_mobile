import 'package:intl/intl.dart';

class SharedFunctions{

  getTimeDifference(String dateTime) {
    DateTime dt = DateTime.parse(dateTime.substring(0,19));
    dt = dt.add(Duration(hours: 5,minutes: 30));
    DateTime now = new DateTime.now();
    String nowString1 = now.toString();
    String nowString2 = nowString1.substring(0,10) + 'T' + nowString1.substring(11,19);
    DateTime dtnow = DateTime.parse(nowString2);
    int difference = dt.difference(dtnow).inMinutes;
    return (difference);
  }

  formatDateTime(String dateTime) {
    DateTime dt = DateTime.parse(dateTime);
    dt = dt.add(Duration(hours: 5,minutes: 30));
    String date = DateFormat.yMd().format(dt);
    String time = DateFormat.jm().format(dt);
    return ('$date at $time');
  }
  
}
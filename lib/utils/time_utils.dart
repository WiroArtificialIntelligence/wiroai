import 'package:intl/intl.dart';

class TimeUtils {
  TimeUtils._();
  
  static bool compareTimes(String time1, String time2) {
    return _convertToMinutes(time1) >= _convertToMinutes(time2);
  }

  static int _convertToMinutes(String time) {
    final timeFormat = DateFormat('hh:mm a');
    final parsedTime = timeFormat.parse(time);
    return parsedTime.hour * 60 + parsedTime.minute;
  }

}



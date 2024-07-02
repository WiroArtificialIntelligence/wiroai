import 'package:intl/intl.dart';

/// A utility class for time-related operations.
class TimeUtils {
  TimeUtils._();
  /// Compares two times in the format 'hh:mm a'.
  /// 
  /// Returns true if the first time is greater than or equal to the second time.
  /// 
  /// - Parameters:
  ///   - time1: A string representing the first time in 'hh:mm a' format (e.g., '02:30 PM').
  ///   - time2: A string representing the second time in 'hh:mm a' format (e.g., '01:45 PM').
  /// - Returns: A boolean value indicating if the first time is greater than or equal to the second time.
  static bool compareTimes(String time1, String time2) {
    return _convertToMinutes(time1) >= _convertToMinutes(time2);
  }
  
  /// Converts a time string to the total number of minutes from midnight.
  /// 
  /// This method parses the time string and calculates the total minutes since midnight.
  /// 
  /// - Parameter time: A string representing the time in 'hh:mm a' format (e.g., '02:30 PM').
  /// - Returns: An integer representing the total number of minutes since midnight.
  static int _convertToMinutes(String time) {
    final timeFormat = DateFormat('hh:mm a');
    final parsedTime = timeFormat.parse(time);
    return parsedTime.hour * 60 + parsedTime.minute;
  }

}



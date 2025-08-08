import 'package:login_app/database_helper.dart';

class AppState {
  static final dbHelper = DatabaseHelper();

  static String? currentLoggedInUserMobile;
  static String? currentLoggedInUserName;
  static bool isUserCheckedIn = false;
  static bool isUserOnBreak = false;
  static String? currentBreakingUserMobile;
  static String? currentBreakingUserName;
  static DateTime? checkInTime;
  static DateTime? breakStartTime;
  static DateTime? breakEndTime;
  static DateTime? checkOutTime;

  static Future<void> initialize() async {
    await dbHelper.database;
  }

  static Future<void> recordCheckIn(String mobile, String name) async {
    if (isUserCheckedIn) return;

    currentLoggedInUserMobile = mobile;
    currentLoggedInUserName = name;
    isUserCheckedIn = true;
    checkInTime = DateTime.now();
    await dbHelper.insertCheckIn(mobile);
  }

  static Future<void> startBreak(String userMobile, String userName) async {
    if (isUserOnBreak) return;

    isUserOnBreak = true;
    breakStartTime = DateTime.now();
    currentBreakingUserMobile = currentLoggedInUserMobile;
    currentBreakingUserName = currentLoggedInUserName;

    // break start record
    if (currentBreakingUserMobile != null) {
      await dbHelper.insertBreakStart(currentBreakingUserMobile!);
    }
  }

  static Future<void> endBreak() async {
    if (!isUserOnBreak) return;

    isUserOnBreak = false;
    breakEndTime = DateTime.now();
    currentBreakingUserMobile = null;
    currentBreakingUserName = null;

    // calling db helper to insert the break end record
    if (currentLoggedInUserMobile != null) {
      await dbHelper.insertBreakEnd(currentLoggedInUserMobile!);
    }
  }

  static Future<void> recordCheckOut() async {
    if (!isUserCheckedIn) return;

    isUserCheckedIn = false;
    checkOutTime = DateTime.now();

    // check-out record
    if (currentLoggedInUserMobile != null) {
      await dbHelper.insertCheckOut(currentLoggedInUserMobile!);
    }
    currentLoggedInUserMobile = null;
    currentLoggedInUserName = null;
    checkInTime = null;
    checkOutTime = null;
    breakStartTime = null;
    breakEndTime = null;
  }

  static Future<Duration> calculateTotalWorkHours(
    String userMobile,
    String userName,
  ) async {
    final dbHelper = DatabaseHelper();
    final records = await dbHelper.getAllAttendanceRecords(userMobile);

    Duration totalHours = Duration.zero;
    for (var record in records) {
      if (record['check_in_time'] != null && record['check_out_time'] != null) {
        final checkIn = DateTime.parse(record['check_in_time']);
        final checkOut = DateTime.parse(record['check_out_time']);
        final breakStart = record['break_start_time'] != null? DateTime.parse(record['break_start_time']): null;
        final breakEnd = record['break_end_time'] != null ? DateTime.parse(record['break_end_time']): null;

        Duration workDuration = checkOut.difference(checkIn);
        if (breakStart != null && breakEnd != null) {
          workDuration -= breakEnd.difference(breakStart);
        }
        totalHours += workDuration;
      }
    }
    return totalHours;
  }

  static void clearAllAttendanceData() {
    currentLoggedInUserMobile = null;
    currentLoggedInUserName = null;
    isUserCheckedIn = false;
    isUserOnBreak = false;
    currentBreakingUserMobile = null;
    currentBreakingUserName = null;
    checkInTime = null;
    breakStartTime = null;
    breakEndTime = null;
    checkOutTime = null;
  }
}

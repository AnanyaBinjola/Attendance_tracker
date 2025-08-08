// import 'package:flutter/material.dart';
// import 'package:login_app/database_helper.dart'; // Import your DatabaseHelper
// import 'package:login_app/appState.dart'; // Import AppState to get current user info
// import 'package:intl/intl.dart'; // Add this for date and time formatting

// class AttendanceHistoryScreen extends StatefulWidget {
//   final String userMobile;
//   final String userName;

//   const AttendanceHistoryScreen({
//     super.key,
//     required this.userMobile,
//     required this.userName,
//   });

//   @override
//   State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
// }

// class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
//   List<Map<String, dynamic>> _attendanceRecords = [];
//   bool _isLoading = true;
//   Duration _totalWorkHours = Duration.zero;

//   @override
//   void initState() {
//     super.initState();
//     _loadAttendanceHistory();
//   }

//   Future<void> _loadAttendanceHistory() async {
//     final dbHelper = DatabaseHelper();
//     // This is a new method you'll need to add to your DatabaseHelper.
//     // It should retrieve all attendance records for a given user.
//     final records = await dbHelper.getAllAttendanceRecords(widget.userMobile);

//     setState(() {
//       _attendanceRecords = records.reversed.toList(); // Display latest first
//       _isLoading = false;
//       _calculateTotalWorkHours();
//     });
//   }

//   void _calculateTotalWorkHours() {
//     Duration totalHours = Duration.zero;
//     for (var record in _attendanceRecords) {
//       if (record['check_in_time'] != null && record['check_out_time'] != null) {
//         final checkIn = DateTime.parse(record['check_in_time']);
//         final checkOut = DateTime.parse(record['check_out_time']);
//         final breakStart = record['break_start_time'] != null ? DateTime.parse(record['break_start_time']) : null;
//         final breakEnd = record['break_end_time'] != null ? DateTime.parse(record['break_end_time']) : null;

//         Duration workDuration = checkOut.difference(checkIn);

//         if (breakStart != null && breakEnd != null) {
//           workDuration -= breakEnd.difference(breakStart);
//         }
//         totalHours += workDuration;
//       }
//     }
//     setState(() {
//       _totalWorkHours = totalHours;
//     });
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final hours = twoDigits(duration.inHours);
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$hours hours, $minutes minutes, $seconds seconds';
//   }

//   String _formatTimestamp(String? timestamp) {
//     if (timestamp == null) {
//       return 'N/A';
//     }
//     final dateTime = DateTime.parse(timestamp);
//     // Use the intl package for better formatting
//     final formatter = DateFormat('dd-MM-yyyy HH:mm:ss');
//     return formatter.format(dateTime.toLocal());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Attendance History'),
//         backgroundColor: Colors.indigo,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Column(
//                       children: [
//                         Text(
//                           'Total Working Hours:',
//                           style: Theme.of(context).textTheme.headlineSmall,
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           _formatDuration(_totalWorkHours),
//                           style: Theme.of(context).textTheme.headlineMedium!.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.indigo,
//                               ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Daily Records:',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const Divider(),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: DataTable(
//                           columnSpacing: 12.0,
//                           headingRowColor: MaterialStateProperty.all(Colors.indigo.shade50),
//                           columns: const [
//                             DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
//                             DataColumn(label: Text('Check-in', style: TextStyle(fontWeight: FontWeight.bold))),
//                             DataColumn(label: Text('Break Start', style: TextStyle(fontWeight: FontWeight.bold))),
//                             DataColumn(label: Text('Break End', style: TextStyle(fontWeight: FontWeight.bold))),
//                             DataColumn(label: Text('Check-out', style: TextStyle(fontWeight: FontWeight.bold))),
//                           ],
//                           rows: _attendanceRecords.map((record) {
//                             final date = record['check_in_time'] != null
//                                 ? DateFormat('dd-MM-yyyy').format(DateTime.parse(record['check_in_time']).toLocal())
//                                 : 'N/A';
//                             return DataRow(
//                               cells: [
//                                 DataCell(Text(date)),
//                                 DataCell(Text(_formatTimestamp(record['check_in_time']))),
//                                 DataCell(Text(_formatTimestamp(record['break_start_time']))),
//                                 DataCell(Text(_formatTimestamp(record['break_end_time']))),
//                                 DataCell(Text(_formatTimestamp(record['check_out_time']))),
//                               ],
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                   ),
//                   if (_attendanceRecords.isEmpty)
//                     const Center(
//                       child: Padding(
//                         padding: EdgeInsets.all(20.0),
//                         child: Text(
//                           'No attendance records found.',
//                           style: TextStyle(fontSize: 16, color: Colors.grey),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//     );
//   }
// }














import 'package:flutter/material.dart';
import 'package:login_app/database_helper.dart'; // Import your DatabaseHelper
import 'package:login_app/appState.dart'; // Import AppState to get current user info
import 'package:intl/intl.dart'; // Add this for date and time formatting

class AttendanceHistoryScreen extends StatefulWidget {
  final String userMobile;
  final String userName;

  const AttendanceHistoryScreen({
    super.key,
    required this.userMobile,
    required this.userName,
  });

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  List<Map<String, dynamic>> _attendanceRecords = [];
  bool _isLoading = true;
  Duration _totalWorkHours = Duration.zero;

  @override
  void initState() {
    super.initState();
    _loadAttendanceHistory();
  }

  Future<void> _loadAttendanceHistory() async {
    final dbHelper = DatabaseHelper();
    final records = await dbHelper.getAllAttendanceRecords(widget.userMobile);

    setState(() {
      _attendanceRecords = records.reversed.toList();
      _isLoading = false;
      _calculateTotalWorkHours();
    });
  }

  void _calculateTotalWorkHours() {
    Duration totalHours = Duration.zero;
    for (var record in _attendanceRecords) {
      if (record['check_in_time'] != null && record['check_out_time'] != null) {
        final checkIn = DateTime.parse(record['check_in_time']);
        final checkOut = DateTime.parse(record['check_out_time']);
        final breakStart = record['break_start_time'] != null ? DateTime.parse(record['break_start_time']) : null;
        final breakEnd = record['break_end_time'] != null ? DateTime.parse(record['break_end_time']) : null;

        Duration workDuration = checkOut.difference(checkIn);

        if (breakStart != null && breakEnd != null) {
          workDuration -= breakEnd.difference(breakStart);
        }
        totalHours += workDuration;
      }
    }
    setState(() {
      _totalWorkHours = totalHours;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours hours, $minutes minutes, $seconds seconds';
  }

  String _formatTimestamp(String? timestamp) {
    if (timestamp == null) {
      return 'N/A';
    }
    final dateTime = DateTime.parse(timestamp);
    final formatter = DateFormat('dd-MM-yyyy HH:mm:ss');
    return formatter.format(dateTime.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
        backgroundColor: Colors.indigo,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Total Working Hours:',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDuration(_totalWorkHours),
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Daily Records:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  // Use a Column and SingleChildScrollView for the table headers and content
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          // Table Header
                          Container(
                            color: Colors.indigo.shade50,
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: Table(
                              columnWidths: const {
                                0: FlexColumnWidth(1.2), // Date
                                1: FlexColumnWidth(1.2), // Check-in
                                2: FlexColumnWidth(1.2), // Break Start
                                3: FlexColumnWidth(1.2), // Break End
                                4: FlexColumnWidth(1.2), // Check-out
                              },
                              children: const [
                                TableRow(
                                  children: [
                                    Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('Check-in', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('Break Start', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('Break End', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('Check-out', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Table Body
                          ..._attendanceRecords.map((record) {
                            final date = record['check_in_time'] != null
                                ? DateFormat('dd-MM-yyyy').format(DateTime.parse(record['check_in_time']).toLocal())
                                : 'N/A';
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.black12)),
                              ),
                              child: Table(
                                columnWidths: const {
                                  0: FlexColumnWidth(1.2),
                                  1: FlexColumnWidth(1.2),
                                  2: FlexColumnWidth(1.2),
                                  3: FlexColumnWidth(1.2),
                                  4: FlexColumnWidth(1.2),
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      Text(date),
                                      Text(_formatTimestamp(record['check_in_time'])),
                                      Text(_formatTimestamp(record['break_start_time'])),
                                      Text(_formatTimestamp(record['break_end_time'])),
                                      Text(_formatTimestamp(record['check_out_time'])),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          if (_attendanceRecords.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  'No attendance records found.',
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
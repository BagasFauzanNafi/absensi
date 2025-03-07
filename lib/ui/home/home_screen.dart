import 'package:attandence_tracker/ui/absent/absent_screen.dart';
import 'package:attandence_tracker/ui/attend/attend_screen.dart';
import 'package:attandence_tracker/ui/attendance_history/attendance_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        _onWillPop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Attendance Tracker',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold ,color:Colors.white ),
          ),
          centerTitle: true,
          backgroundColor: Colors.deepOrange,
        ),
        backgroundColor: Colors.grey[100],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildCard(
                        context,
                        icon: Icons.check_circle,
                        title: 'Mark Attendance',
                        color: Colors.green,
                        page: const AttendScreen(),
                      ),
                      _buildCard(
                        context,
                        icon: Icons.event_busy,
                        title: 'Absence Request',
                        color: Colors.orange,
                        page: const AbsentScreen(),
                      ),
                      _buildCard(
                        context,
                        icon: Icons.history,
                        title: 'Attendance History',
                        color: Colors.blue,
                        page: const AttendanceHistoryScreen(),
                      ),
                      _buildCard(
                        context,
                        icon: Icons.exit_to_app,
                        title: 'Exit App',
                        color: Colors.red,
                        onTap: () => _onWillPop(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required IconData icon,
        required String title,
        required Color color,
        Widget? page,
        VoidCallback? onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: InkWell(
        onTap: onTap ?? () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page!),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Exit Confirmation',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to exit the app?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel', style: TextStyle(fontSize: 14)),
          ),
          ElevatedButton(
            onPressed: () => SystemNavigator.pop(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Exit', style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    ));
  }
}

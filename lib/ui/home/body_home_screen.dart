import 'package:attandence_tracker/get_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BodyHomeScreen extends StatelessWidget {
  const BodyHomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students Attendance'),
      ),
      body: Center(
        child: Column(
          children: [
            Lottie.asset('assets/raw/office.json'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GetLocationScreen(),
                  ),
                );
              },
              child: const Text('Get Location'),
            )
          ],
        ),
      ),
    );
  }
}

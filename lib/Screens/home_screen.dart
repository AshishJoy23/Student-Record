import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:student_record_hive/core/constants.dart';
import 'package:student_record_hive/screens/add_student.dart';
import 'package:student_record_hive/screens/view_students.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'HOME',
          style: kAppbarTitleStyle,
        ),
      ),
      backgroundColor: kScaffoldBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/animations/home1.json'),
                kHeight20,
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ScreenViewStudent()));
                  },
                  icon: const Icon(Icons.view_list),
                  label: const Padding(
                    padding: EdgeInsets.only(
                        top: 14.0, bottom: 14.0, left: 4.5, right: 4.5),
                    child: Text(
                      'View Students',
                      style: kButtonStyle,
                    ),
                  ),
                ),
                kHeight10,
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ScreenAddStudent()));
                  },
                  icon: const Icon(Icons.add),
                  label: const Padding(
                    padding: EdgeInsets.all(13.0),
                    child: Text(
                      'Add Student',
                      style: kButtonStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

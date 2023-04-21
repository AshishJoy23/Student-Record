import 'package:flutter/material.dart';
import 'package:student_record_hive/Screens/add_student.dart';
import 'package:student_record_hive/Screens/view_students.dart';


class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HOME',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 229, 238, 249),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.black45),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>  const ScreenViewStudent()));
                  },
                  icon: const Icon(Icons.view_list),
                  label: const Padding(
                    padding: EdgeInsets.only(
                        top: 14.0, bottom: 14.0, left: 4.5, right: 4.5),
                    child: Text(
                      'View Students',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const ScreenAddStudent()));
                  },
                  icon: const Icon(Icons.add),
                  label: const Padding(
                    padding: EdgeInsets.all(13.0),
                    child: Text(
                      'Add Student',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
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

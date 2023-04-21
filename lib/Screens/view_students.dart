import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student_record_hive/Screens/each_student_info.dart';
import 'package:student_record_hive/Screens/home_screen.dart';
import 'package:student_record_hive/database/functions/db_functions.dart';
import 'package:student_record_hive/database/model/db_model.dart';

class ScreenViewStudent extends StatefulWidget {
  const ScreenViewStudent({super.key});

  @override
  State<ScreenViewStudent> createState() => _ScreenViewStudentState();
}

class _ScreenViewStudentState extends State<ScreenViewStudent> {
  @override
  Widget build(BuildContext context) {
    getAllStudents();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 207, 228, 255),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const ScreenHome()));
            },
            icon: const Icon(Icons.arrow_back_rounded)),
        title: const Text(
          'Registered Students',
          style: TextStyle(color: Colors.white),    
        ),
      ),
      body: ValueListenableBuilder(
          valueListenable: studentListNotifier,
          builder:
              (BuildContext ctx, List<StudentModel> studentList, Widget? _) {
            return ListView.separated(
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (ctx, index) {
                final data = studentList[index];
                return Card(
                  elevation: 0,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: FileImage(File(data.image)),
                      radius: 50,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EachStudentInfo(index: index)),
                      );
                    },
                    title: Text(data.name),
                    subtitle: const Text('Click to get Info'),
                    trailing: IconButton(
                      onPressed: () {
                        // if (data.id != null) {
                          showAlertDialog(context,index);
                        // }
                      },
                      icon: const Icon(Icons.delete),
                      color: Colors.black,
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: studentList.length,
            );
          }),
    );
  }

  showAlertDialog(BuildContext contxt, int dbId) {
    Widget cancelButton = ElevatedButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget okButton = ElevatedButton(
      child: const Text("Ok"),
      onPressed: () {
        deleteStudent(dbId);
        ScaffoldMessenger.of(contxt).showSnackBar(const SnackBar(
            backgroundColor: Color.fromARGB(255, 49, 185, 11),
            margin: EdgeInsets.all(20),
            behavior: SnackBarBehavior.floating,
            content: Text("Item deleted Successfully"),
            duration: Duration(seconds: 2)));
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("AlertDialog"),
      content: const Text("Do you Want to Delete ?"),
      actions: [
        cancelButton,
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

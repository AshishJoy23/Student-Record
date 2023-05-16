import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:student_record_hive/core/constants.dart';
import 'package:student_record_hive/screens/each_student_info.dart';
import 'package:student_record_hive/database/functions/db_functions.dart';
import 'package:student_record_hive/database/model/db_model.dart';
import 'package:student_record_hive/screens/search_screen.dart';

class ScreenViewStudent extends StatelessWidget {
  const ScreenViewStudent({super.key});

  @override
  Widget build(BuildContext context) {
    getAllStudents();
    return Scaffold(
      backgroundColor: kScaffoldBgColor,
      appBar: AppBar(
        leading: IconButton(
          icon: kLeadingIcon,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Registered Students',
          style: kAppbarTitleStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ScreenSearch()));
            },
            icon: const Icon(
              Icons.search,
              size: 28,
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: studentListNotifier,
          builder:
              (BuildContext ctx, List<StudentModel> studentList, Widget? _) {
            if (studentList.isEmpty) {
              return Center(
                child: Lottie.asset('assets/animations/no_data1.json'),
              );
            }
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
                        showAlertDialog(context, index);
                        // }
                      },
                      icon: const Icon(Icons.delete),
                      color: Colors.redAccent,
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return kHeight10;
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
        Navigator.pop(contxt);
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
        Navigator.pop(contxt);
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
      context: contxt,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

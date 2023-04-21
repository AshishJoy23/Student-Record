import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_record_hive/Screens/update_student.dart';
import 'package:student_record_hive/database/functions/db_functions.dart';
import 'package:student_record_hive/database/model/db_model.dart';

class EachStudentInfo extends StatefulWidget {
  final index;
  const EachStudentInfo({Key? key, required this.index}) : super(key: key);

  @override
  State<EachStudentInfo> createState() => _EachStudentInfoState();
}

class _EachStudentInfoState extends State<EachStudentInfo> {
 

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: studentListNotifier,
        builder:
            (BuildContext ctx, List<StudentModel> studentlist, Widget? child) {
          final data = studentlist[widget.index];
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: const Color.fromARGB(255, 229, 238, 249),
            appBar: AppBar(
              title: Text('${data.name} Info'),
              actions: [
                IconButton(
                    onPressed: () {
                      //editIconPressed(context, widget.index);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ScreenUpdation(index: widget.index)),
                      );
                    },
                    icon: const Icon(Icons.edit_note),
                    iconSize: 40,)
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  CircleAvatar(
                    backgroundImage: FileImage(File(data.image)),
                    radius: 100,
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      display("Name:", data.name.toUpperCase()),
                      dividerstyle,
                      display("Age:", data.age),
                      dividerstyle,
                      display("Course:", data.course),
                      dividerstyle,
                      display("DOB:", parseDate(data.date)),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget display(field, data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          field,
          style: const TextStyle(fontSize: 25),
        ),
        const SizedBox(
          width: 12,
        ),
        Text(
          data,
          style: const TextStyle(fontSize: 25),
        )
      ],
    );
  }

  Widget dividerstyle = const Divider(
    color: Colors.grey,
    thickness: 2,
    indent: 20,
    endIndent: 20,
  );

  String parseDate(DateTime displayDate){
    return DateFormat.yMMMd('en_US').format(displayDate);
  }
}

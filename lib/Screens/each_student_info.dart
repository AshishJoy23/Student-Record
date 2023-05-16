import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_record_hive/core/constants.dart';
import 'package:student_record_hive/screens/update_student.dart';
import 'package:student_record_hive/database/functions/db_functions.dart';
import 'package:student_record_hive/database/model/db_model.dart';

class EachStudentInfo extends StatelessWidget {
  final int index;
  EachStudentInfo({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: studentListNotifier,
        builder:
            (BuildContext ctx, List<StudentModel> studentlist, Widget? child) {
          final data = studentlist[index];
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: kScaffoldBgColor,
            appBar: AppBar(
              leading: IconButton(
                icon:kLeadingIcon,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text('${data.name} Info',style: kAppbarTitleStyle,),
              actions: [
                IconButton(
                  onPressed: () {
                    //editIconPressed(context, widget.index);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ScreenUpdation(index: index)),
                    );
                  },
                  icon: const Icon(Icons.edit_note),
                  iconSize: 40,
                )
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  kHeight50,
                  CircleAvatar(
                    backgroundImage: FileImage(File(data.image)),
                    radius: 100,
                  ),
                  Column(
                    children: [
                      kHeight50,
                      display("Name :", data.name.toUpperCase()),
                      dividerstyle,
                      display("Age :", data.age),
                      dividerstyle,
                      display("Course :", data.course),
                      dividerstyle,
                      display("DOB :", parseDate(data.date)),
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
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                field,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        kWidth10,
        Expanded(
          child: Row(
            children: [
              Text(
                data,
                style: const TextStyle(fontSize: 22,fontWeight: FontWeight.w500),
              ),
            ],
          ),
        )
      ],
    );
  }

}

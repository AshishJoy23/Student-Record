import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:student_record_hive/database/functions/db_functions.dart';
import 'package:student_record_hive/database/model/db_model.dart';

final updateNameController = TextEditingController();
final updateAgeController = TextEditingController();
final updateCourseController = TextEditingController();
DateTime? updateDate;
ImagePicker imagePicker = ImagePicker();
XFile? updatedImageFile;

Future<void> editIconPressed(BuildContext context, int index) async {
  updateNameController.text = studentListNotifier.value[index].name;
  updateAgeController.text = studentListNotifier.value[index].age;
  updateCourseController.text = studentListNotifier.value[index].course;
  // updatedImageFile!.path = studentListNotifier.value[index].image;
  return showDialog(
    context: context,
    builder: (context) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: AlertDialog(
            title: const Text('Update Student Info'),
            content: SingleChildScrollView(
              reverse: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      pickUpdatedImage(ImageSource.gallery);
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 60,
                          backgroundImage: updatedImageFile != null
                              ? FileImage(File(updatedImageFile!.path))
                                  as ImageProvider
                              : FileImage(
                                  File(studentListNotifier.value[index].image)),
                        ),
                        Positioned(
                          right: -24,
                          bottom: -3,
                          child: RawMaterialButton(
                            onPressed: () {
                              pickUpdatedImage(ImageSource.camera);
                            },
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white24,
                              child: Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  TextField(
                    onChanged: (value) {},
                    controller: updateNameController,
                    decoration: InputDecoration(
                        hintText: studentListNotifier.value[index].name),
                  ),
                  TextField(
                    onChanged: (value) {},
                    controller: updateAgeController,
                    decoration: InputDecoration(
                        hintText: studentListNotifier.value[index].age),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    onChanged: (value) {},
                    controller: updateCourseController,
                    decoration: InputDecoration(
                        hintText: studentListNotifier.value[index].course),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      final updatedDateTemp = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 365 * 100)),
                          lastDate: DateTime.now());
                      if (updatedDateTemp == null) {
                        log('$updatedDateTemp date in return');
                        return;
                      } else {
                        // setState(() {
                        updateDate = updatedDateTemp;

                        // });
                      }
                    },
                    icon: const Icon(
                      Icons.calendar_month,
                      size: 40.0,
                    ),
                    label: Text(updateDate == null
                        ? parseDate(studentListNotifier.value[index].date)
                        : parseDate(updateDate!)),
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        onUpdateButtonClicked(index, context);

                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.done),
                      label: const Text('Update')),
                ],
              ),
            ),
          ));
    },
  );
}

Future<void> pickUpdatedImage(ImageSource source) async {
  XFile? updatedFile = await ImagePicker().pickImage(source: source);
  // setState(() {
  updatedImageFile = updatedFile;
  // });
}

String parseDate(DateTime displayDate) {
  return DateFormat.yMMMd('en_US').format(displayDate);
}

Future<void> onUpdateButtonClicked(int index, context) async {
  log('calll to updation function');
  String? image = updatedImageFile?.path;
  if (image == null) {
    log('retrn');
    // return;
    image = studentListNotifier.value[index].image;
  }

  final updatedName = updateNameController.text;
  final updatedAge = updateAgeController.text;
  final updatedCourse = updateCourseController.text;
  final updatedImage = image;
  final updatedDate = updateDate ?? studentListNotifier.value[index].date;

  if (updatedName.isEmpty ||
      updatedAge.isEmpty ||
      updatedCourse.isEmpty ||
      updatedDate.toString().isEmpty) {
    log('inside if fun');
    return;
  } else {
    log('$updatedImage image pibk');
    log(updatedDate.toString());
    log('else');
    final updatedStudent = StudentModel(
        name: updatedName,
        age: updatedAge,
        date: updatedDate,
        course: updatedCourse,
        image: updatedImage);

    updateStudent(updatedStudent, index);

    // updateStudent(updatedStudent, index);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        margin: EdgeInsets.all(10),
        content: Text('Updated Successfully'),
        duration: Duration(seconds: 2)));
  }
}

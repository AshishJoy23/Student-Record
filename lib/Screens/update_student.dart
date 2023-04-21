import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:student_record_hive/database/functions/db_functions.dart';
import 'package:student_record_hive/database/model/db_model.dart';

class ScreenUpdation extends StatefulWidget {
  final index;
  const ScreenUpdation({Key? key, required this.index}) : super(key: key);

  @override
  State<ScreenUpdation> createState() => _ScreenUpdationState();
}

class _ScreenUpdationState extends State<ScreenUpdation> {
  final updateNameController = TextEditingController();
  final updateAgeController = TextEditingController();
  final updateCourseController = TextEditingController();
  DateTime? updateDate;
  ImagePicker imagePicker = ImagePicker();
  XFile? updatedImageFile;

  @override
  Widget build(BuildContext context) {
    updateNameController.text = studentListNotifier.value[widget.index].name;
    updateAgeController.text = studentListNotifier.value[widget.index].age;
    updateCourseController.text =
        studentListNotifier.value[widget.index].course;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Updation Page',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 207, 228, 255),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 30.0,
                ),
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
                            : FileImage(File(
                                studentListNotifier.value[widget.index].image)),
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
                dividerArea(),
                const Text('Select a Photo'),
                dividerArea(),
                displayTextField(updateNameController, TextInputType.text,
                    studentListNotifier.value[widget.index].name),
                dividerArea(),
                displayTextField(updateAgeController, TextInputType.number,
                    studentListNotifier.value[widget.index].age),
                dividerArea(),
                displayTextField(updateCourseController, TextInputType.text,
                    studentListNotifier.value[widget.index].course),
                dividerArea(),
                TextButton.icon(
                  onPressed: () async {
                    final updatedDateTemp = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now()
                            .subtract(const Duration(days: 365 * 100)),
                        lastDate: DateTime.now());
                    if (updatedDateTemp == null) {
                      return;
                    } else {
                      setState(() {
                        updateDate = updatedDateTemp;
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.calendar_month,
                    size: 40.0,
                  ),
                  label: Text(updateDate == null
                      ? parseDate(studentListNotifier.value[widget.index].date)
                      : parseDate(updateDate!)),
                ),
                dividerArea(),
                ElevatedButton.icon(
                    onPressed: () {
                      onUpdateButtonClicked(widget.index, context);
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.done),
                    label: const Text('Update')),
              ],
            ),
          ),
        )));
  }

  Future<void> pickUpdatedImage(ImageSource source) async {
    XFile? updatedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      updatedImageFile = updatedFile;
    });
  }

  Widget displayTextField(controller, keyboardType, hintText) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          border: const OutlineInputBorder(), hintText: hintText),
    );
  }

  Widget dividerArea() {
    return const SizedBox(height: 10);
  }

  String parseDate(DateTime displayDate) {
    return DateFormat.yMMMd('en_US').format(displayDate);
  }

  Future<void> onUpdateButtonClicked(int index, context) async {
    String? image = updatedImageFile?.path;
    if (image==null) {
      log('retrn');
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
      return;
    } else {
      final updatedStudent = StudentModel(
          name: updatedName,
          age: updatedAge,
          date: updatedDate,
          course: updatedCourse,
          image: updatedImage);

      updateStudent(updatedStudent, index);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          margin: EdgeInsets.all(10),
          content: Text('Updated Successfully'),
          duration: Duration(seconds: 2)));
    }
  }
}

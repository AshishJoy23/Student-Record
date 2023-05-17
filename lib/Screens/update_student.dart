import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_record_hive/bloc/image_picker/image_picker_bloc.dart';
import 'package:student_record_hive/bloc/list_view/list_view_bloc.dart';
import 'package:student_record_hive/bloc/select_date/select_date_bloc.dart';
import 'package:student_record_hive/core/constants.dart';
import 'package:student_record_hive/database/functions/db_functions.dart';
import 'package:student_record_hive/database/model/db_model.dart';

class ScreenUpdation extends StatefulWidget {
  final int index;
  const ScreenUpdation({Key? key, required this.index}) : super(key: key);

  @override
  State<ScreenUpdation> createState() => _ScreenUpdationState();
}

class _ScreenUpdationState extends State<ScreenUpdation> {
  final updateNameController = TextEditingController();
  final updateAgeController = TextEditingController();
  final updateCourseController = TextEditingController();
  DateTime? _updateDate;
  XFile? updatedImageFile;
  List<StudentModel> studentList = studentBox.values.toList();

  @override
  Widget build(BuildContext context) {
    log('update screen build>>>>>>>>>>>>><<<<');
    updateNameController.text = studentList[widget.index].name;
    updateAgeController.text = studentList[widget.index].age;
    updateCourseController.text = studentList[widget.index].course;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: kLeadingIcon,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Updation Page',
            style: kAppbarTitleStyle,
          ),
        ),
        backgroundColor: kScaffoldBgColor,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                kHeight50,
                BlocBuilder<ImagePickerBloc, ImagePickerState>(
                  builder: (context, state) {
                    updatedImageFile = state.image;
                    return GestureDetector(
                      onTap: () {
                        BlocProvider.of<ImagePickerBloc>(context)
                            .add(ChooseImage());
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
                                    File(studentList[widget.index].image)),
                          ),
                          Positioned(
                            right: -24,
                            bottom: -3,
                            child: RawMaterialButton(
                              onPressed: () {
                                BlocProvider.of<ImagePickerBloc>(context)
                                    .add(CaptureImage());
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
                    );
                  },
                ),
                kHeight10,
                kHeight10,
                displayTextField(updateNameController, TextInputType.text,
                    studentList[widget.index].name),
                kHeight10,
                displayTextField(updateAgeController, TextInputType.number,
                    studentList[widget.index].age),
                kHeight10,
                displayTextField(updateCourseController, TextInputType.text,
                    studentList[widget.index].course),
                kHeight10,
                BlocBuilder<SelectDateBloc, SelectDateState>(
                  builder: (context, state) {
                    _updateDate = state.date;
                    return TextButton.icon(
                      onPressed: () async {
                        BlocProvider.of<SelectDateBloc>(context)
                            .add(ChooseDOB(context: context));
                      },
                      icon: const Icon(
                        Icons.calendar_month,
                        size: 40.0,
                      ),
                      label: Text(_updateDate == null
                          ? parseDate(studentList[widget.index].date)
                          : parseDate(_updateDate!)),
                    );
                  },
                ),
                kHeight10,
                ElevatedButton.icon(
                  onPressed: () {
                    onUpdateButtonClicked(widget.index, context);
                  },
                  icon: const Icon(Icons.done),
                  label: const Text(
                    'Update',
                    style: kButtonStyle,
                  ),
                ),
              ],
            ),
          ),
        )));
  }

  Future<void> onUpdateButtonClicked(int index, context) async {
    final String? updatedName = updateNameController.text;
    final String? updatedAge = updateAgeController.text;
    final String? updatedCourse = updateCourseController.text;
    final String? updatedImage;
    DateTime? updatedDate;

    if (updatedImageFile == null) {
      updatedImage = studentList[index].image;
    } else {
      updatedImage = updatedImageFile!.path;
    }

    if (_updateDate == null) {
      updatedDate = studentList[index].date;
    } else {
      updatedDate = _updateDate;
    }

    if (updatedName!.isEmpty ||
        updatedAge!.isEmpty ||
        updatedCourse!.isEmpty ||
        updatedDate.toString().isEmpty ||
        updatedImage.isEmpty) {
      showSnackBarMsg(context, Colors.redAccent, 'All fields are required');
      return;
    }

    ageValidation(context, updatedAge);
    nameValidation(context, updatedName);

    final updatedStudent = StudentModel(
        name: updatedName,
        age: updatedAge,
        date: updatedDate!,
        course: updatedCourse,
        image: updatedImage);

    await updateStudent(updatedStudent, index);
    showSnackBarMsg(context, Colors.green, 'Updated Successfully');
    BlocProvider.of<ListViewBloc>(context).add(StudentListView());
    Navigator.pop(context);
  }
}

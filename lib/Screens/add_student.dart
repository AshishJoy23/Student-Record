// ignore_for_file: use_build_context_synchronously, unnecessary_nullable_for_final_variable_declarations

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_record_hive/bloc/image_picker/image_picker_bloc.dart';
import 'package:student_record_hive/bloc/select_date/select_date_bloc.dart';
import 'package:student_record_hive/core/constants.dart';
import 'package:student_record_hive/screens/view_students.dart';
import 'package:student_record_hive/database/functions/db_functions.dart';
import 'package:student_record_hive/database/model/db_model.dart';


class ScreenAddStudent extends StatefulWidget {
  const ScreenAddStudent({super.key});

  @override
  State<ScreenAddStudent> createState() => ScreenAddStudentState();
}

class ScreenAddStudentState extends State<ScreenAddStudent> {
  final TextEditingController _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _courseController = TextEditingController();
  DateTime? _selectedDate;
  final ImagePicker picker = ImagePicker();
  XFile? imageFile;

  // @override
  // void initState() {
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    log('add student page build>>>>>>>>>>>>.');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: kLeadingIcon,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Student Details',
          style: kAppbarTitleStyle,
        ),
      ),
      backgroundColor: kScaffoldBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                kHeight10,
                BlocBuilder<ImagePickerBloc, ImagePickerState>(
                  builder: (BuildContext context, state) {
                    imageFile = state.image;
                    return GestureDetector(
                      onTap: () {
                        BlocProvider.of<ImagePickerBloc>(context)
                            .add(ChooseImage());
                        //pickSelectedImage(ImageSource.gallery);
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 60,
                            backgroundImage: (imageFile != null)
                                ? FileImage(File(imageFile!.path))
                                    as ImageProvider
                                : const AssetImage(
                                    'assets/images/default_logo.jpg'),
                          ),
                          Positioned(
                            right: -24,
                            bottom: -3,
                            child: RawMaterialButton(
                              onPressed: () {
                                BlocProvider.of<ImagePickerBloc>(context)
                                    .add(CaptureImage());
                                //pickSelectedImage(ImageSource.camera);
                              },
                              child: const CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white10,
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
                const Text('Select a Photo'),
                kHeight10,
                displayTextField(_nameController, TextInputType.text, 'Name'),
                kHeight10,
                displayTextField(_ageController, TextInputType.number, 'Age'),
                kHeight10,
                displayTextField(
                    _courseController, TextInputType.text, 'Course'),
                kHeight10,
                BlocBuilder<SelectDateBloc, SelectDateState>(
                  builder: (context, state) {
                    log(state.date.toString());
                    _selectedDate = state.date;
                    return TextButton.icon(
                      onPressed: () async {
                        BlocProvider.of<SelectDateBloc>(context)
                            .add(ChooseDOB(context: context));
                        // final selectedDateTemp = await showDatePicker(
                        //   context: context,
                        //   initialDate: DateTime.now(),
                        //   firstDate: DateTime.now()
                        //       .subtract(const Duration(days: 365 * 100)),
                        //   lastDate: DateTime.now(),
                        // );
                        // if (selectedDateTemp == null) {
                        //   return;
                        // } else {
                        //   _selectedDate = selectedDateTemp;
                        // }
                      },
                      icon: const Icon(
                        Icons.calendar_month,
                        size: 40.0,
                      ),
                      label: Text(_selectedDate == null
                          ? 'DOB'
                          : parseDate(_selectedDate!)),
                    );
                  },
                ),
                kHeight10,
                ElevatedButton(
                  onPressed: () {
                    saveButtonPressed(context);
                  },
                  // icon: const Icon(Icons.view_list),
                  child: const Padding(
                    padding: EdgeInsets.only(
                        top: 14.0, bottom: 14.0, left: 4.5, right: 4.5),
                    child: Text(
                      'Save',
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

  // Future<void> pickSelectedImage(ImageSource source) async {
  //   XFile? pickedFile = await ImagePicker().pickImage(source: source);
  //   setState(() {
  //     imageFile = pickedFile;
  //   });
  // }

  Future<void> saveButtonPressed(BuildContext contxt) async {
    final String? nameText = _nameController.text.trim();
    final String? ageText = _ageController.text.trim();
    final String? courseText = _courseController.text.trim();
    final String? selectedImage;

    if (imageFile == null) {
      selectedImage = '';
    } else {
      selectedImage = imageFile!.path;
    }

    if (nameText!.isEmpty ||
        ageText!.isEmpty ||
        courseText!.isEmpty ||
        selectedImage.isEmpty ||
        _selectedDate.toString().isEmpty) {
      showSnackBarMsg(context, Colors.redAccent, 'All fields are required');
      return;
    }

    ageValidation(context, ageText);
    nameValidation(context, nameText);
    

    final student = StudentModel(
      name: nameText,
      age: ageText,
      date: _selectedDate!,
      course: courseText,
      image: selectedImage,
    );

    await addStudent(student);

    showSnackBarMsg(context, const Color.fromARGB(255, 49, 185, 11), 'Added Successfully');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ScreenViewStudent(),
      ),
    );
  }
}

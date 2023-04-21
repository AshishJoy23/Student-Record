// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:student_record_hive/Screens/home_screen.dart';
import 'package:student_record_hive/Screens/view_students.dart';
import 'package:student_record_hive/database/functions/db_functions.dart';
import 'package:student_record_hive/database/model/db_model.dart';

// final ImagePicker picker = ImagePicker();
// XFile? imageFile;

class ScreenAddStudent extends StatefulWidget {
  const ScreenAddStudent({super.key});

  @override
  State<ScreenAddStudent> createState() => ScreenAddStudentState();
}

class ScreenAddStudentState extends State<ScreenAddStudent> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _courseController = TextEditingController();
  DateTime? _selectedDate;
  final ImagePicker picker = ImagePicker();
  XFile? imageFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const ScreenHome()));
            },
            icon: const Icon(Icons.arrow_back_rounded)),
        title: const Text(
          'Student Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 207, 228, 255),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                dividerArea(),
                GestureDetector(
                  onTap: () {
                    pickSelectedImage(ImageSource.gallery);
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 60,
                        backgroundImage: imageFile != null
                            ? FileImage(File(imageFile!.path)) as ImageProvider
                            : const NetworkImage(
                                'https://static.vecteezy.com/system/resources/thumbnails/000/350/111/small/Education__28193_29.jpg'),
                      ),
                      Positioned(
                        right: -24,
                        bottom: -3,
                        child: RawMaterialButton(
                          onPressed: () {
                            pickSelectedImage(ImageSource.camera);
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
                ),
                dividerArea(),
                const Text('Select a Photo'),
                dividerArea(),
                displayTextField(_nameController,TextInputType.text,'Name'),
                dividerArea(),
                displayTextField(_ageController,TextInputType.number,'Age'),
                dividerArea(),
                displayTextField(_courseController,TextInputType.text,'Course'),
                dividerArea(),
                TextButton.icon(
                  onPressed: () async {
                    final _selectedDateTemp = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now()
                            .subtract(const Duration(days: 365 * 100)),
                        lastDate: DateTime.now());
                    if (_selectedDateTemp == null) {
                      return;
                    } else {
                      setState(() {
                        _selectedDate = _selectedDateTemp;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_month,size: 40.0,),
                  label: Text(
                      _selectedDate == null ? 'DOB' : parseDate(_selectedDate!)),
                ),
                dividerArea(),
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

  Future<void> pickSelectedImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      imageFile = pickedFile;
    });
  }

  Widget displayTextField(_controller,_keyboardType,_hintText){
   return TextFormField(
      controller: _controller,
      keyboardType: _keyboardType,
      decoration: InputDecoration(
          border: const OutlineInputBorder(), 
          hintText: _hintText),
    );
  }

  Widget dividerArea(){
    return const SizedBox(height: 10);
  }

  String parseDate(DateTime displayDate){
    return DateFormat.yMMMd('en_US').format(displayDate);
  }

  Future<void> saveButtonPressed(BuildContext contxt) async {
    final nameText = _nameController.text.trim();
    final ageText = _ageController.text.trim();
    final courseText = _courseController.text.trim();
    final selectedImage = imageFile!.path.toString();

    if (nameText.isEmpty ||
        ageText.isEmpty ||
        courseText.isEmpty ||
        selectedImage.isEmpty ||
        _selectedDate.toString().isEmpty) {
      return;
    }

    final student = StudentModel(
      name: nameText,
      age: ageText,
      date: _selectedDate!,
      course: courseText,
      image: selectedImage,
    );

    addStudent(student);
    ScaffoldMessenger.of(contxt).showSnackBar(const SnackBar(
            backgroundColor: Color.fromARGB(255, 49, 185, 11),
            margin: EdgeInsets.all(20),
            behavior: SnackBarBehavior.floating,
            content: Text("Added Successfully"),
            duration: Duration(seconds: 2)));
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ScreenViewStudent()));
  }
}

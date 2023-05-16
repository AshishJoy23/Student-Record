import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_record_hive/database/model/db_model.dart';


ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);

Future<void> addStudent(StudentModel value) async{
  final studentDB = await Hive.openBox<StudentModel>('student-db');
  await studentDB.add(value);
  studentListNotifier.value.add(value);
  studentListNotifier.notifyListeners();
}

Future<void> getAllStudents() async{
  final studentDB = await Hive.openBox<StudentModel>('student-db');
  studentListNotifier.value.clear();
  studentListNotifier.value.addAll(studentDB.values);
  studentListNotifier.notifyListeners();
  
}

Future<void> deleteStudent(int id) async{
  final studentDB = await Hive.openBox<StudentModel>('student-db');
  await studentDB.deleteAt(id);
  getAllStudents();
}

Future<void> updateStudent(StudentModel value, int id) async {
  final studentDB = await Hive.openBox<StudentModel>('student-db');
  await studentDB.putAt(id, value);
  studentListNotifier.notifyListeners();
  getAllStudents();
}

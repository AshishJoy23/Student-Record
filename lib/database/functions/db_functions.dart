import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_record_hive/database/model/db_model.dart';


ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);

Future<void> addStudent(StudentModel value) async{
  final studentDB = await Hive.openBox<StudentModel>('student-db');
  final dbid = await studentDB.add(value);
  value.id = dbid;
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
  await studentDB.delete(id);
  getAllStudents();
}

Future<void> updateStudent(StudentModel values, int id) async {
  final studentDB = await Hive.openBox<StudentModel>('student-db');
  final key = studentDB.keys;
  final savedKey = key.elementAt(id);
  await studentDB.putAt(savedKey, values);
  studentListNotifier.notifyListeners();
  getAllStudents();
}

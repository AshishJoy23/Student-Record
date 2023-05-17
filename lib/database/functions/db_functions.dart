import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_record_hive/database/model/db_model.dart';


late Box<StudentModel> studentBox;
openStudentBox() async {
  studentBox = await Hive.openBox('student-db');
}

Future<void> addStudent(StudentModel value) async {
  await studentBox.add(value);
}

Future<void> updateStudent(StudentModel value, int id) async {
  await studentBox.putAt(id, value);
}

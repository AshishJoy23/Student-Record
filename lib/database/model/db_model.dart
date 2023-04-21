import 'package:hive/hive.dart';
part 'db_model.g.dart';



@HiveType(typeId: 1)
class StudentModel{

  @HiveField(0)
  int? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String age;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  final String course;

  @HiveField(5)
  final String image;

  StudentModel({
    required this.name,
    required this.age,
    required this.date,
    required this.course,
    required this.image,
    this.id
  });
}
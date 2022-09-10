import 'package:hive/hive.dart';
part 'student_model.g.dart';

@HiveType(typeId: 0)
class StudentModel {

  @HiveField(0)
  final String name;

  @HiveField(1)
  final int marks;

  StudentModel({required this.name,required this.marks});
}
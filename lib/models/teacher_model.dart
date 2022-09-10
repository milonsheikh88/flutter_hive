import 'package:hive/hive.dart';
part 'teacher_model.g.dart';
///flutter packages pub run build_runner build --delete-conflicting-outputs
@HiveType(typeId: 1)
class TeacherModel {

  @HiveField(0)
  final String name;

  @HiveField(1)
  final String mobile;

  @HiveField(2)
  final String email;

  TeacherModel({required this.name, required this.mobile, required this.email});
}
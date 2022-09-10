import 'package:hive/hive.dart';
part 'bank_model.g.dart';
///flutter packages pub run build_runner build --delete-conflicting-outputs
@HiveType(typeId: 2)
class BankModel {

  @HiveField(0)
  final String name;

  @HiveField(1, defaultValue: 0)
  final int accountNumber;

  @HiveField(2, defaultValue: 0)
  final int amount;

  BankModel({required this.name, required this.accountNumber, required this.amount});
}
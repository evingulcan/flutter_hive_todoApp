import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'task_model.g.dart';

// flutter packages pub run build_runner build
// flutter packages pub run build_runner build --delete-conflicting-outputs
@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  late String name;
  @HiveField(2)
  final DateTime createdAt;
  @HiveField(3)
  late bool isCompleted;

  Task(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.isCompleted});

//Constructors geriye herhangi bir şey döndürmüyor.
//factory'ye dediğimizde artık return edebiliyoruz.
  factory Task.create(String name, DateTime createdAt) {
    //id 'yi bilmiyoruz dışarıdan da almayacagız.UUid o anki zamanı  string'e dönüştürüp bize veriyor.
    return Task(
        id: const Uuid().v1(),
        name: name,
        createdAt: createdAt,
        isCompleted: false);
  }
}

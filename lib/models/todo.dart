import 'package:objectbox/objectbox.dart';

@Entity()
class Todo {
  @Id(assignable: true)
  int id;
  String title;
  bool isCompleted;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  Todo({
    this.id = 0,
    required this.title,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

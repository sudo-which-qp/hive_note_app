import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel {
  @HiveField(0)
  final String? title;

  @HiveField(1)
  final String? notes;

  @HiveField(2)
  final dynamic dateTime;

  NoteModel({
    this.title,
    this.notes,
    this.dateTime,
  });
}

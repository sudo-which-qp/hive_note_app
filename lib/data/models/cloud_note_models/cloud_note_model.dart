import 'package:hive/hive.dart';

part 'cloud_note_model.g.dart';

@HiveType(typeId: 1)
class CloudNoteModel {
  @HiveField(1)
  final int? id;

  @HiveField(2)
  final String? uuid;

  @HiveField(3)
  final String? title;

  @HiveField(4)
  final String? notes;

  CloudNoteModel({
    this.id,
    this.uuid,
    this.title,
    this.notes,
  });

  factory CloudNoteModel.fromJson(Map<String, dynamic> response) {
    return CloudNoteModel(
      id: response['id'],
      uuid: response['uuid'],
      title: response['note_title'],
      notes: response['note_content'],
    );
  }

  static List<CloudNoteModel> parseResponse(Map<String, dynamic> responseData) {
    if (responseData['success'] == true && responseData['data'] != null) {
      List<dynamic> noteData = responseData['data'];
      return noteData.map((json) => CloudNoteModel.fromJson(json)).toList();
    }
    return [];
  }

}
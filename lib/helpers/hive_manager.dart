import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/app/resources/home/views/cloud_notes/models/cloud_note_model.dart';
import 'package:note_app/data/models/cloud_note_models/user_model.dart';
import 'package:note_app/app/resources/home/views/local_notes/models/note_model.dart';
import 'package:note_app/utils/const_values.dart';
import 'package:path_provider/path_provider.dart';

class HiveManager {
  static final HiveManager _instance = HiveManager._internal();

  factory HiveManager() {
    return _instance;
  }

  HiveManager._internal();

  static late Box<NoteModel> _noteModelBox;
  static late Box<NoteModel> _deleteNoteModelBox;
  static late Box<CloudNoteModel> _cloudNoteModelBox;
  static late Box<UserModel> _userModelBox;

  Future<void> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    Hive
      ..init(directory.path)
      ..registerAdapter(NoteModelAdapter());
    _noteModelBox = await Hive.openBox<NoteModel>(noteBox);
    _deleteNoteModelBox = await Hive.openBox<NoteModel>(deletedNotes);

    Hive
      ..init(directory.path)
      ..registerAdapter(CloudNoteModelAdapter());
    _cloudNoteModelBox = await Hive.openBox<CloudNoteModel>(cloudNoteBox);

    Hive
      ..init(directory.path)
      ..registerAdapter(UserModelAdapter());
    _userModelBox = await Hive.openBox<UserModel>(userBox);

  }


  Box<NoteModel> get noteModelBox => _noteModelBox;
  Box<NoteModel> get deleteNoteModelBox => _deleteNoteModelBox;
  Box<CloudNoteModel> get cloudNoteModelBox => _cloudNoteModelBox;
  Box<UserModel> get userModelBox => _userModelBox;

}
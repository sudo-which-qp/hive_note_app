import 'package:note_app/data/models/cloud_note_models/cloud_note_model.dart';
import 'package:note_app/data/network/network_services_api.dart';
import 'package:note_app/helpers/hive_manager.dart';
import 'package:note_app/utils/const_values.dart';

class CloudNoteRepository {
  final NetworkServicesApi _api;
  final HiveManager _hiveManager;

  CloudNoteRepository({
    required NetworkServicesApi api,
    required HiveManager hiveManager,
  })  : _api = api,
        _hiveManager = hiveManager;

  String? _getToken() {
    return _hiveManager.userModelBox.get(tokenKey)?.accessToken;
  }

  Future<List<CloudNoteModel>> fetchNotes() async {
    try {
      final token = _getToken();

      final response = await _api.getApi(
        requestEnd: 'user/fetch_notes',
        bearer: token,
      );

      // logger.i('Fetch Notes Response: $response');

      if (response['success'] == true) {
        List<CloudNoteModel> cloudNotes = CloudNoteModel.parseResponse(response);

        await _hiveManager.cloudNoteModelBox.clear();
        await _hiveManager.cloudNoteModelBox.addAll(cloudNotes);

        return cloudNotes;
      }

      throw response['message'] ?? 'Failed to fetch notes';
    } catch (e) {
      logger.e('Error in fetchNotes: $e');
      throw e.toString();
    }
  }

  Future<CloudNoteModel> createNote(String title, String content) async {
    try {
      final token = _getToken();

      final response = await _api.postApi(
        requestEnd: 'user/create_notes',
        params: {
          'note_title': title,
          'note_content': content,
        },
        bearer: token,
      );

      logger.i('Create Note Response: $response');

      if (response['success'] == true) {
        return CloudNoteModel.fromJson(response['data']);
      }

      throw response['message'] ?? 'Failed to create note';
    } catch (e) {
      logger.e('Error in createNote: $e');
      throw e.toString();
    }
  }

  Future<CloudNoteModel> updateNote(CloudNoteModel note) async {
    try {
      final token = _getToken();

      final response = await _api.postApi(
        requestEnd: 'user/edit_notes',
        params: {
          'note_uuid': note.uuid,
          'note_title': note.title,
          'note_content': note.notes,
        },
        bearer: token,
      );

      logger.i('Update Note Response: $response');

      if (response['success'] == true) {
        return CloudNoteModel.fromJson(response['data']);
      }

      throw response['message'] ?? 'Failed to update note';
    } catch (e) {
      logger.e('Error in updateNote: $e');
      throw e.toString();
    }
  }

  Future<CloudNoteModel> moveToTrash(CloudNoteModel note) async {
    try {
      final token = _getToken();

      final response = await _api.postApi(
        requestEnd: 'user/trash_note',
        params: {
          'note_uuid': note.uuid,
          'note_title': note.title,
          'note_content': note.notes,
        },
        bearer: token,
      );

      logger.i('Update Note Response: $response');

      if (response['success'] == true) {
        return CloudNoteModel.fromJson(response['data']);
      }

      throw response['message'] ?? 'Failed to update note';
    } catch (e) {
      logger.e('Error in deleteNote: $e');
      throw e.toString();
    }
  }

  Future<CloudNoteModel> moveToCloud(String title, String content, int noteKey) async {
    try {
      final token = _getToken();

      final response = await _api.postApi(
        requestEnd: 'user/move_to_cloud',
        params: {
          'note_title': title,
          'note_content': content,
        },
        bearer: token,
      );

      logger.i('Create Note Response: $response');

      if (response['success'] == true) {
        _hiveManager.noteModelBox.deleteAt(noteKey);
        return CloudNoteModel.fromJson(response['data']);
      }

      throw response['message'] ?? 'Failed to create note';
    } catch (e) {
      logger.e('Error in createNote: $e');
      throw e.toString();
    }
  }

}
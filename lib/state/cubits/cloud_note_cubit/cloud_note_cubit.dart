import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:note_app/data/models/cloud_note_models/cloud_note_model.dart';
import 'package:note_app/data/repositories/cloud_note_repository.dart';
import 'package:note_app/utils/const_values.dart';

part 'cloud_note_state.dart';

class CloudNoteCubit extends Cubit<CloudNoteState> {
  final CloudNoteRepository _repository;

  CloudNoteCubit({
    required CloudNoteRepository repository,
  })  : _repository = repository,
        super(CloudNoteInitial());

  Future<void> fetchNotes() async {
    try {
      emit(CloudNoteLoading());

      final notes = await _repository.fetchNotes();
      final hiveKeys = _repository.getHiveKeys();
      emit(CloudNoteLoaded(notes, hiveKeys),);
    } catch (e) {
      logger.e('Error in fetchNotes: $e');
      emit(CloudError(e.toString()));
    }
  }

  Future<void> moveToCloud(String? title, String? content, int noteKey) async {
    try {
      emit(CloudNoteLoading());

      await _repository.moveToCloud(title!, content!, noteKey);
      emit(CloudNoteSuccess());
    } catch (e) {
      logger.e('Error in fetchNotes: $e');
      emit(CloudError(e.toString()));
    }
  }

  Future<void> createNote(String? title, String? content) async {
    try {
      emit(CloudNoteLoading());

      final note = await _repository.createNote(title!, content!);
      emit(CloudNoteCreated(note));

    } catch (e) {
      logger.e('Error in fetchNotes: $e');
      emit(CloudError(e.toString()));
    }
  }

  Future<void> editNote(CloudNoteModel cloudNote, int noteKey) async {
    try {
      emit(CloudNoteLoading());

      final updatedNote = await _repository.updateNote(cloudNote, noteKey);

      emit(CloudNoteUpdated(updatedNote));

    } catch (e) {
      logger.e('Error in fetchNotes: $e');
      emit(CloudError(e.toString()));
    }
  }

  Future<void> deleteNote(CloudNoteModel cloudNote) async {
    try {
      emit(CloudNoteLoading());

      await _repository.moveToTrash(cloudNote);

      emit(CloudNoteDeleted());

    } catch (e) {
      logger.e('Error in fetchNotes: $e');
      emit(CloudError(e.toString()));
    }
  }

}

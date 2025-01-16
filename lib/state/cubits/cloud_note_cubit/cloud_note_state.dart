part of 'cloud_note_cubit.dart';

abstract class CloudNoteState extends Equatable {
  const CloudNoteState();

  @override
  List<Object?> get props => [];
}

class CloudNoteInitial extends CloudNoteState {}

class CloudNoteLoading extends CloudNoteState {}

class CloudNoteLoaded extends CloudNoteState {
  final List<CloudNoteModel> notes;

  const CloudNoteLoaded(this.notes);

  @override
  List<Object?> get props => [notes];
}

class CloudNoteSingleLoaded extends CloudNoteState {
  final CloudNoteModel note;

  const CloudNoteSingleLoaded(this.note);

  @override
  List<Object?> get props => [note];
}

class CloudNoteCreated extends CloudNoteState {
  final CloudNoteModel note;

  const CloudNoteCreated(this.note);

  @override
  List<Object?> get props => [note];
}

class CloudNoteUpdated extends CloudNoteState {
  final CloudNoteModel note;

  const CloudNoteUpdated(this.note);

  @override
  List<Object?> get props => [note];
}

class CloudNoteDeleted extends CloudNoteState {
  final int noteId;

  const CloudNoteDeleted(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

class CloudError extends CloudNoteState {
  final String message;

  const CloudError(this.message);

  @override
  List<Object?> get props => [message];
}

class CloudNoteMoved extends CloudNoteState {
  final CloudNoteModel note;

  const CloudNoteMoved(this.note);

  @override
  List<Object?> get props => [note];
}

class CloudNoteSuccess extends CloudNoteState {}
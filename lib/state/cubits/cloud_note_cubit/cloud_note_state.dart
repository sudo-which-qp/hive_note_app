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
  final List<int> hiveKeys;

  const CloudNoteLoaded(this.notes, this.hiveKeys);

  @override
  List<Object?> get props => [notes, hiveKeys];
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

class CloudNoteDeleted extends CloudNoteState {}

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

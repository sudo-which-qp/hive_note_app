part of 'note_style_cubit.dart';

class NoteStyleState extends Equatable {
  final bool viewStyle;

  const NoteStyleState({
    this.viewStyle = false,
  });

  factory NoteStyleState.initial() {
    return const NoteStyleState();
  }

  @override
  List<Object> get props => [viewStyle];

  NoteStyleState copyWith({
    bool? viewStyle,
  }) {
    return NoteStyleState(
      viewStyle: viewStyle ?? this.viewStyle,
    );
  }
}

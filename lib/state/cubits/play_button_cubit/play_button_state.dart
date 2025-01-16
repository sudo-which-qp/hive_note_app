part of 'play_button_cubit.dart';

@immutable
class PlayButtonState extends Equatable {
  final bool canPlay;

  const PlayButtonState({
    this.canPlay = false,
  });

  factory PlayButtonState.initial() {
    return const PlayButtonState();
  }

  @override
  List<Object> get props => [canPlay];

  PlayButtonState copyWith({
    bool? canPlay,
  }) {
    return PlayButtonState(
      canPlay: canPlay ?? this.canPlay,
    );
  }
}

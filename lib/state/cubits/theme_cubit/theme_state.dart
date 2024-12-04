part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final bool isDarkTheme;

  const ThemeState({
    this.isDarkTheme = false,
  });

  factory ThemeState.initial() {
    return const ThemeState();
  }

  @override
  List<Object> get props => [isDarkTheme];

  ThemeState copyWith({
    bool? isDarkTheme,
  }) {
    return ThemeState(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
    );
  }
}


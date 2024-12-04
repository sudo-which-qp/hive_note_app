import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  String key = 'appTheme';
  SharedPreferences? _pref;

  ThemeCubit() : super(ThemeState.initial()) {
    _loadFromPref();
  }

  /*
  there seems to be an issue with the cubit setup for the theme state
  changing. what I noticed was when the app loads up, the theme flashes a bit
  as if it is a bit confused on which state it should be either dark or light.

  I hope to figure this out soon, but for now we will work with this.
  */

  // initialize the shared Preference Instance
  Future<void> _initPrefs() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  // Load the data from it and check the current value
  Future<void> _loadFromPref() async {
    await _initPrefs();
    final bool isDarkTheme = _pref!.getBool(key) ?? false;
    emit(state.copyWith(isDarkTheme: isDarkTheme));
  }

  // save the new value to the key
  Future<void> _saveToPref(bool value) async {
    await _initPrefs();
    await _pref!.setBool(key, value);
  }

  // toggle between light or dark mode
  void toggleTheme() {
    final newThemeValue = !state.isDarkTheme;
    _saveToPref(newThemeValue);
    emit(state.copyWith(isDarkTheme: newThemeValue));
  }

}

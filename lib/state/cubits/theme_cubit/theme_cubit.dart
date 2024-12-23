import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  String key = 'appTheme';
  SharedPreferences? _pref;

  ThemeCubit(this._pref)
      : super(ThemeState(isDarkTheme: _pref!.getBool('appTheme') ?? false));

  // initialize the shared Preference Instance
  Future<void> _initPrefs() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  // Load the data from it and check the current value
  /*
  This function is no longer needed but is kept for future reference
   */
  Future<void> _loadFromPref() async {
    await _initPrefs();
    final bool isDarkTheme = _pref?.getBool(key) ?? false;
    emit(state.copyWith(isDarkTheme: isDarkTheme));
  }

  // save the new value to the key
  /*
  This function is no longer needed but is kept for future reference
   */
  Future<void> _saveToPref(bool value) async {
    await _initPrefs();
    await _pref!.setBool(key, value);
  }

  // toggle between light or dark mode
  Future<void> toggleTheme() async {
    final newThemeValue = !state.isDarkTheme;
    _pref!.setBool(key, newThemeValue);
    emit(state.copyWith(isDarkTheme: newThemeValue));
  }
}

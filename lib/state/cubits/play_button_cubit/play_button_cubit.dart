import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'play_button_state.dart';

class PlayButtonCubit extends Cubit<PlayButtonState> {
  String key = 'playButton';
  SharedPreferences? _pref;


  PlayButtonCubit() : super(PlayButtonState.initial()) {
    _loadFromPref();
  }

  // initialize the shared Preference Instance
  Future<void> _initPrefs() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  // Load the data from it and check the current value
  Future<void> _loadFromPref() async {
    await _initPrefs();
    final bool canPlay = _pref!.getBool(key) ?? false;
    emit(state.copyWith(canPlay: canPlay));
  }

  // save the new value to the key
  Future<void> _saveToPref(bool value) async {
    await _initPrefs();
    await _pref!.setBool(key, value);
  }

  // toggle between light or dark mode
  void togglePlayButton() {
    final newCanPlay = !state.canPlay;
    _saveToPref(newCanPlay);
    emit(state.copyWith(canPlay: newCanPlay));
  }

}

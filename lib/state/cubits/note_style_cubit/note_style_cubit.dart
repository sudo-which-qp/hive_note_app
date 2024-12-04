import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'note_style_state.dart';

class NoteStyleCubit extends Cubit<NoteStyleState> {
  String key = 'changeViewStyle';
  SharedPreferences? _pref;

  NoteStyleCubit() : super(NoteStyleState.initial()) {
    _loadFromPref();
  }

  // initialize the shared Preference Instance
  Future<void> _initPrefs() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  // Load the data from it and check the current value
  Future<void> _loadFromPref() async {
    await _initPrefs();
    final bool viewStyle = _pref!.getBool(key) ?? false;
    emit(state.copyWith(viewStyle: viewStyle));
  }

  // save the new value to the key
  Future<void> _saveToPref(bool value) async {
    await _initPrefs();
    await _pref!.setBool(key, value);
  }

  // toggle between light or dark mode
  void toggleNoteStyle() {
    final newViewStyle = !state.viewStyle;
    _saveToPref(newViewStyle);
    emit(state.copyWith(viewStyle: newViewStyle));
  }
}

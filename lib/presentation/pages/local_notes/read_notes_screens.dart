import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/config/router/navigates_to.dart';
import 'package:note_app/config/router/routes_name.dart';
import 'package:note_app/data/models/local_note_model/note_model.dart';
import 'package:note_app/helpers/hive_manager.dart';
import 'package:note_app/state/cubits/auth_cubit/auth_cubit.dart';
import 'package:note_app/state/cubits/cloud_note_cubit/cloud_note_cubit.dart';
import 'package:note_app/state/cubits/play_button_cubit/play_button_cubit.dart';
import 'package:note_app/state/cubits/theme_cubit/theme_cubit.dart';
import 'package:note_app/utils/colors/m_colors.dart';
import 'package:note_app/utils/const_values.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:note_app/utils/tools/message_dialog.dart';
import 'package:provider/provider.dart';

class ReadNotesScreen extends StatefulWidget {
  final NoteModel? note;
  final int? noteKey;

  const ReadNotesScreen({
    Key? key,
    @required this.note,
    @required this.noteKey,
  }) : super(key: key);

  @override
  _ReadNotesScreenState createState() => _ReadNotesScreenState();
}

enum TtsState {
  playing,
  stopped,
  paused,
  continued,
}

class _ReadNotesScreenState extends State<ReadNotesScreen> {
  FlutterTts? flutterTts;
  dynamic languages;
  String? language;
  double? volume = 0.5;
  double? pitch = 0.2;
  double? rate = 0.4;

  String? _newVoiceText;

  TtsState ttsState = TtsState.stopped;

  bool get isIOS => !kIsWeb && Platform.isIOS;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  bool get isWeb => kIsWeb;

  @override
  void initState() {
    super.initState();
    initTts();
    _onChange(widget.note!.notes.toString());
  }

  void initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    // flutterTts.setVoice("en-us-x-sfg#male_1-local");
    flutterTts!.setLanguage('en-Us');

    if (isAndroid) {
      _getEngines();
    }

    flutterTts!.setStartHandler(() {
      setState(() {
        logger.i('Playing');
        ttsState = TtsState.playing;
      });
    });

    flutterTts!.setCompletionHandler(() {
      setState(() {
        logger.i('Complete');
        ttsState = TtsState.stopped;
      });
    });

    flutterTts!.setCancelHandler(() {
      setState(() {
        logger.i('Cancel');
        ttsState = TtsState.stopped;
      });
    });

    if (isWeb || isIOS) {
      flutterTts!.setPauseHandler(() {
        setState(() {
          logger.i('Paused');
          ttsState = TtsState.paused;
        });
      });

      flutterTts!.setContinueHandler(() {
        setState(() {
          logger.i('Continued');
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts!.setErrorHandler((msg) {
      setState(() {
        logger.i('error: $msg');
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts!.getLanguages;
    if (languages != null) setState(() => languages);
  }

  Future _getEngines() async {
    var engines = await flutterTts!.getEngines;
    if (engines != null) {
      for (dynamic engine in engines) {
        logger.i(engine);
      }
    }
  }

  Future _speak() async {
    await flutterTts!.setVolume(volume!);
    await flutterTts!.setSpeechRate(rate!);
    await flutterTts!.setPitch(pitch!);

    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        await flutterTts!.awaitSpeakCompletion(true);
        await flutterTts!.speak(_newVoiceText!);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts!.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  // Android does not support pause as of this moment
  // Future _pause() async {
  //   var result =
  //       await flutterTts.setSilence(widget.note.notes.toString().length);
  //   if (result == 1) setState(() => ttsState = TtsState.paused);
  // }

  @override
  void dispose() {
    super.dispose();
    flutterTts!.stop();
  }

  void _onChange(String text) {
    setState(() {
      _newVoiceText = text;
    });
  }

  final bool isEditing = true;

  Widget showText() {
    dynamic test;
    setState(() {
      test = SelectableText(
        widget.note!.notes.toString(),
        style: const TextStyle(
          fontSize: 18.0,
        ),
      );
    });
    return test;
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CloudNoteCubit, CloudNoteState>(
      listener: (context, state) {
        if (state is CloudNoteSuccess) {
          Navigator.pop(context);
        } else if (state is CloudError) {
          showError(state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Read Note',
          ),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          actions: <Widget>[
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return BlocBuilder<CloudNoteCubit, CloudNoteState>(
                    builder: (context, state) {
                      return state is CloudNoteLoading
                          ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                color: context
                                            .watch<ThemeCubit>()
                                            .state
                                            .isDarkTheme ==
                                        false
                                    ? AppColors.defaultBlack
                                    : AppColors.defaultWhite,
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.cloud_upload_outlined),
                              onPressed: state is! CloudNoteLoading
                                  ? () {
                                      context
                                          .read<CloudNoteCubit>()
                                          .moveToCloud(
                                            '${widget.note!.title}',
                                            '${widget.note!.notes}',
                                            widget.noteKey!,
                                          );
                                    }
                                  : null,
                            );
                    },
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.mode_edit),
              onPressed: () {
                Navigator.pop(context);
                navigateTo(context,
                    destination: RoutesName.edit_notes_screen,
                    arguments: {
                      'notes': widget.note,
                      'noteKey': widget.noteKey,
                    });
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Center(
                    child: Text(
                      '${widget.note!.title}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                showText(),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            context.watch<PlayButtonCubit>().state.canPlay == false
                ? FloatingActionButton(
                    backgroundColor: Colors.white60,
                    onPressed: () {
                      ttsState == TtsState.stopped ? _speak() : _stop();
                    },
                    child: Icon(
                      ttsState == TtsState.stopped
                          ? Icons.play_circle_outline
                          : Icons.stop_circle_outlined,
                      color: Colors.black45,
                    ),
                  )
                : null,
      ),
    );
  }
}

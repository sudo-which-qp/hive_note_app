import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:note_app/data/models/cloud_note_models/cloud_note_model.dart';
import 'package:note_app/state/cubits/play_button_cubit/play_button_cubit.dart';
import 'package:note_app/utils/const_values.dart';
import 'package:provider/provider.dart';

class CloudReadNote extends StatefulWidget {
  final CloudNoteModel? note;
  final int? noteKey;

  const CloudReadNote({
    super.key,
    @required this.note,
    @required this.noteKey,
  });

  @override
  State<CloudReadNote> createState() => _CloudReadNoteState();
}

enum TtsCloudState {
  playing,
  stopped,
  paused,
  continued,
}

class _CloudReadNoteState extends State<CloudReadNote> {
  FlutterTts? flutterTts;
  dynamic languages;
  String? language;
  double? volume = 0.5;
  double? pitch = 0.2;
  double? rate = 0.4;

  String? _newVoiceText;

  TtsCloudState ttsState = TtsCloudState.stopped;

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
        ttsState = TtsCloudState.playing;
      });
    });

    flutterTts!.setCompletionHandler(() {
      setState(() {
        logger.i('Complete');
        ttsState = TtsCloudState.stopped;
      });
    });

    flutterTts!.setCancelHandler(() {
      setState(() {
        logger.i('Cancel');
        ttsState = TtsCloudState.stopped;
      });
    });

    if (isWeb || isIOS) {
      flutterTts!.setPauseHandler(() {
        setState(() {
          logger.i('Paused');
          ttsState = TtsCloudState.paused;
        });
      });

      flutterTts!.setContinueHandler(() {
        setState(() {
          logger.i('Continued');
          ttsState = TtsCloudState.continued;
        });
      });
    }

    flutterTts!.setErrorHandler((msg) {
      setState(() {
        logger.i('error: $msg');
        ttsState = TtsCloudState.stopped;
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
    if (result == 1) setState(() => ttsState = TtsCloudState.stopped);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Read Note',
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.mode_edit),
            onPressed: () {
              Navigator.pop(context);
              // navigateTo(context,
              //     destination: CloudEditNote(
              //       notes: widget.note,
              //       noteKey: widget.noteKey,
              //     ));
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
      floatingActionButton: context.watch<PlayButtonCubit>().state.canPlay
          ? FloatingActionButton(
              backgroundColor: Colors.white60,
              onPressed: () {
                ttsState == TtsCloudState.stopped ? _speak() : _stop();
              },
              child: Icon(
                ttsState == TtsCloudState.stopped
                    ? Icons.play_circle_outline
                    : Icons.stop_circle_outlined,
                color: Colors.black45,
              ),
            )
          : null,
    );
  }
}

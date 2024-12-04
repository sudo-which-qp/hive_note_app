import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_app/helpers/hive_manager.dart';
import 'package:note_app/state/cubits/theme_cubit/theme_cubit.dart';
import 'package:provider/provider.dart';

class CloudCreateNote extends StatefulWidget {
  const CloudCreateNote({super.key});

  @override
  State<CloudCreateNote> createState() => _CloudCreateNoteState();
}

class _CloudCreateNoteState extends State<CloudCreateNote> {
  final TextEditingController _noteTitle = TextEditingController();
  final TextEditingController _noteText = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextStyle? myTextStyle;
  TextAlign? myTextAlign;

  bool? _isNotEmpty;

  final goToNotes = FocusNode();

  Future<bool> checkIfNoteIsNotEmptyWhenGoingBack() async {
    final storeData = HiveManager().cloudNoteModelBox;
    if (_noteText.text.isNotEmpty || _noteTitle.text.isNotEmpty) {
      final String noteTitle = _noteTitle.text;
      final String note = _noteText.text;

      // createNote(noteTitle, note);

      await Fluttertoast.showToast(
        msg: 'Note Saved',
        toastLength: Toast.LENGTH_SHORT,
      );
      if(mounted) {
        // context.pop();
        // context.pushNamed(RoutesName.cloud_notes);
      }
      _isNotEmpty = true;
    } else {
      await Fluttertoast.showToast(
        msg: 'Note was empty, nothing was saved',
        toastLength: Toast.LENGTH_SHORT,
      );
      if(mounted) {
        // context.pop();
        // context.pushNamed(RoutesName.cloud_notes);
      }
      _isNotEmpty = false;
    }
    return _isNotEmpty!;
  }

  void checkIfNoteIsNotEmptyAndSaveNote() {
    final storeData = HiveManager().cloudNoteModelBox;
    if (_noteTitle.text.isEmpty || _noteText.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Title or note body cannot be empty',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    } else {
      final String noteTitle = _noteTitle.text;
      final String note = _noteText.text;

      // createNote(noteTitle, note);

      Fluttertoast.showToast(
        msg: 'Note Saved',
        toastLength: Toast.LENGTH_SHORT,
      );
      // context.pop();
      // context.pushNamed(RoutesName.cloud_notes);
    }
  }

  @override
  void initState() {
    super.initState();
    myTextStyle = const TextStyle(
      fontSize: 18.5,
    );
    myTextAlign = TextAlign.left;
  }

  @override
  void dispose() {
    super.dispose();
    _noteTitle.dispose();
    _noteText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: checkIfNoteIsNotEmptyWhenGoingBack,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          // used a text form field for the app bar
          leading: Platform.isIOS
              ? IconButton(
                  icon: const Icon(CupertinoIcons.back),
                  onPressed: checkIfNoteIsNotEmptyWhenGoingBack,
                )
              : null,
          title: TextFormField(
            autofocus: true,
            controller: _noteTitle,
            decoration: const InputDecoration(
              hintText: 'Create Note Title...',
              hintStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
            ),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(goToNotes);
            },
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
          ),
          // ends here //
          centerTitle: false,
          actions: <Widget>[
            TextButton.icon(
              onPressed: () {
                checkIfNoteIsNotEmptyAndSaveNote();
              },
              icon: Icon(
                Icons.done,
                color:
                context.watch<ThemeCubit>().state.isDarkTheme == false ? Colors.black45 : Colors.white38,
              ),
              label: Text(
                'Save',
                style: TextStyle(
                  color: context.watch<ThemeCubit>().state.isDarkTheme == false
                      ? Colors.black45
                      : Colors.white38,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              controller: _noteText,
              decoration: const InputDecoration(
                hintText: 'Type Note...',
                hintStyle: TextStyle(),
                border: InputBorder.none,
              ),
              textCapitalization: TextCapitalization.sentences,
              focusNode: goToNotes,
              style: myTextStyle,
              textAlign: myTextAlign!,
              maxLines: height.toInt(),
            ),

            //TODO! trying to add styling functionality, having issues
            //TODO! persisting the style for a saved note
          ),
        ),
      ),
    );
  }
}

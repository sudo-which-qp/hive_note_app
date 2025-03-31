import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_app/data/models/local_note_model/note_model.dart';
import 'package:note_app/helpers/hive_manager.dart';
import 'package:note_app/presentation/pages/local_notes/local_notes.dart';
import 'package:note_app/state/cubits/theme_cubit/theme_cubit.dart';
import 'package:note_app/utils/tools/slide_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({Key? key}) : super(key: key);
  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final TextEditingController _noteTitle = TextEditingController();

  // Quill controllers
  late QuillController _quillController;
  final FocusNode _quillFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool? _isNotEmpty;
  final goToNotes = FocusNode();

  @override
  void initState() {
    super.initState();
    // Initialize the Quill controller with empty document
    _quillController = QuillController.basic();
  }

  @override
  void dispose() {
    _noteTitle.dispose();
    _quillController.dispose();
    _quillFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Convert Quill document to JSON string for storage
  String _getQuillContentAsJson() {
    return jsonEncode(_quillController.document.toDelta().toJson());
  }

  // Check if Quill document is empty
  bool _isQuillContentEmpty() {
    final delta = _quillController.document.toDelta();
    // Check if there's only one empty line or no content
    return delta.length <= 1 &&
        (delta.isEmpty ||
            (delta.length == 1 && delta.first.data == '\n'));
  }

  Future<bool> checkIfNoteIsNotEmptyWhenGoingBack() async {
    final storeData = HiveManager().noteModelBox;

    if (!_isQuillContentEmpty() || _noteTitle.text.isNotEmpty) {
      final String noteTitle = _noteTitle.text;
      final String noteContent = _getQuillContentAsJson();

      NoteModel noteM = NoteModel(
        title: noteTitle,
        notes: noteContent,
        // dateTime: DateTime.now().toString(),
      );

      await storeData.add(noteM);
      await Fluttertoast.showToast(
        msg: 'Note Saved',
        toastLength: Toast.LENGTH_SHORT,
      );

      if(mounted) {
        Navigator.of(context).pop();
        await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return const LocalNotesScreen();
        }));
      }
      _isNotEmpty = true;
    } else {
      await Fluttertoast.showToast(
        msg: 'Note was empty, nothing was saved',
        toastLength: Toast.LENGTH_SHORT,
      );

      if(mounted) {
        Navigator.of(context).pop();
        await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return const LocalNotesScreen();
        }));
      }
      _isNotEmpty = false;
    }
    return _isNotEmpty!;
  }

  void checkIfNoteIsNotEmptyAndSaveNote() {
    final storeData = HiveManager().noteModelBox;

    if (_noteTitle.text.isEmpty || _isQuillContentEmpty()) {
      Fluttertoast.showToast(
        msg: 'Title or note body cannot be empty',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    } else {
      final String noteTitle = _noteTitle.text;
      final String noteContent = _getQuillContentAsJson();

      NoteModel noteM = NoteModel(
        title: noteTitle,
        notes: noteContent,
        // dateTime: DateTime.now().toString(),
      );

      storeData.add(noteM);
      Fluttertoast.showToast(
        msg: 'Note Saved',
        toastLength: Toast.LENGTH_SHORT,
      );

      Navigator.of(context).pop();
      Navigator.of(context).push(MySlide(builder: (_) {
        return const LocalNotesScreen();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: checkIfNoteIsNotEmptyWhenGoingBack,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
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
              FocusScope.of(context).requestFocus(_quillFocusNode);
            },
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
          ),
          centerTitle: false,
          actions: <Widget>[
            TextButton.icon(
              onPressed: checkIfNoteIsNotEmptyAndSaveNote,
              icon: Icon(
                Icons.done,
                color: context.watch<ThemeCubit>().state.isDarkTheme == false
                    ? Colors.black45
                    : Colors.white38,
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
        body: Column(
          children: [
            // Quill Toolbar
            QuillSimpleToolbar(
              controller: _quillController,
              config: const QuillSimpleToolbarConfig(
                showFontFamily: true,
                showFontSize: false,
                showBackgroundColorButton: false,
                showColorButton: true,
                showClearFormat: true,
                showCodeBlock: false,
                showInlineCode: false,
                showListCheck: true,
                showListBullets: true,
                showListNumbers: true,
                showQuote: true,
                showStrikeThrough: true,
                showUnderLineButton: true,
                showDividers: false,
                showHeaderStyle: true,
                showLink: false,
                showSearchButton: false,
                showAlignmentButtons: true,
              ),
            ),
            // Quill Editor
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: QuillEditor(
                  focusNode: _quillFocusNode,
                  scrollController: _scrollController,
                  controller: _quillController,
                  config: const QuillEditorConfig(
                    placeholder: 'Type Note...',
                    scrollable: true,
                    padding: EdgeInsets.all(0),
                    autoFocus: false,
                    expands: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
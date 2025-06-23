import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_app/config/router/navigates_to.dart';
import 'package:note_app/config/router/routes_name.dart';
import 'package:note_app/data/models/local_note_model/note_model.dart';
import 'package:note_app/helpers/hive_manager.dart';
import 'package:note_app/state/cubits/auth_cubit/auth_cubit.dart';
import 'package:note_app/state/cubits/cloud_note_cubit/cloud_note_cubit.dart';
import 'package:note_app/state/cubits/theme_cubit/theme_cubit.dart';
import 'package:note_app/utils/colors/m_colors.dart';
import 'package:note_app/utils/tools/message_dialog.dart';
import 'package:provider/provider.dart';

class ReadNotesScreen extends StatefulWidget {
  final NoteModel? note;
  final int? noteKey;
  final Map? args;

  const ReadNotesScreen({
    Key? key,
    @required this.note,
    @required this.noteKey,
    @required this.args,
  }) : super(key: key);

  @override
  _ReadNotesScreenState createState() => _ReadNotesScreenState();
}

class _ReadNotesScreenState extends State<ReadNotesScreen> {
  late QuillController _quillController;
  final ScrollController _scrollController = ScrollController();
  bool _showTools = false;

  @override
  void initState() {
    super.initState();
    // Initialize quill controller from the note
    _quillController = widget.note!.quillController;
  }

  @override
  void dispose() {
    _quillController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  var _initValue = {'note': '', 'conText': ''};

  var _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _noteText = widget.notes.notes;
    if (_isInit) {
      _initValue = {
        'title': widget.note!.title.toString(),
        'notes': widget.note!.notes.toString(),
        'conText': widget.note!.notes.toString()
      };
    }
    _isInit = false;
  }

  void showEditingTools() {
    setState(() {
      _showTools = !_showTools;
    });
  }

  // Convert Quill document to JSON string for storage
  String _getQuillContentAsJson() {
    return jsonEncode(_quillController.document.toDelta().toJson());
  }


  void checkIfNoteIsNotEmptyAndSaveNote() {
    final storeData = HiveManager().noteModelBox;

    String? title = _initValue['title'];
    final String noteContent = _getQuillContentAsJson();

    NoteModel noteM = NoteModel(
      title: title,
      notes: noteContent,
      // dateTime: DateTime.now().toString(),
    );

    var key = widget.noteKey;

    storeData.put(key, noteM);
    Fluttertoast.showToast(
      msg: 'Note Updated',
      toastLength: Toast.LENGTH_SHORT,
    );
    Navigator.pop(context);
  }

  Future<bool> checkIfNoteIsNotEmptyWhenGoingBack() async {
    final storeData = HiveManager().noteModelBox;

    String? title = _initValue['title'];
    final String noteContent = _getQuillContentAsJson();

    NoteModel noteM = NoteModel(
      title: title,
      notes: noteContent,
      // dateTime: DateTime.now().toString(),
    );

    var key = widget.noteKey;

    storeData.put(key, noteM);
    Fluttertoast.showToast(
      msg: 'Note Updated',
      toastLength: Toast.LENGTH_SHORT,
    );
    Navigator.pop(context);

    return true;
  }

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
      child: WillPopScope(
        onWillPop: checkIfNoteIsNotEmptyWhenGoingBack,
        child: Scaffold(
          appBar: AppBar(
            title: TextFormField(
              initialValue: widget.note!.title,
              onChanged: (val) {
                _initValue['title'] = val;
              },
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
                // FocusScope.of(context).requestFocus(goToNotes);
              },
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
            ),
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            actions: <Widget>[
              // Cannot allow uploading to Cloud at the moment,
              // because the package for rich text markdown is saving data as json
              // so I will need to prepare the data to be saved properly and
              // displayed on the cloud note screen

              // BlocBuilder<AuthCubit, AuthState>(
              //   builder: (context, state) {
              //     if (state is AuthAuthenticated) {
              //       return BlocBuilder<CloudNoteCubit, CloudNoteState>(
              //         builder: (context, state) {
              //           return state is CloudNoteLoading
              //               ? SizedBox(
              //                   width: 20.w,
              //                   height: 20.w,
              //                   child: CircularProgressIndicator(
              //                     color: context
              //                                 .watch<ThemeCubit>()
              //                                 .state
              //                                 .isDarkTheme ==
              //                             false
              //                         ? AppColors.defaultBlack
              //                         : AppColors.defaultWhite,
              //                   ),
              //                 )
              //               : IconButton(
              //                   icon: const Icon(Icons.cloud_upload_outlined),
              //                   onPressed: state is! CloudNoteLoading
              //                       ? () {
              //                           context
              //                               .read<CloudNoteCubit>()
              //                               .moveToCloud(
              //                                 '${widget.note!.title}',
              //                                 '${widget.note!.notes}',
              //                                 widget.noteKey!,
              //                               );
              //                         }
              //                       : null,
              //                 );
              //         },
              //       );
              //     } else {
              //       return const SizedBox();
              //     }
              //   },
              // ),
              TextButton.icon(
                onPressed: checkIfNoteIsNotEmptyAndSaveNote,
                icon: Icon(
                  Icons.done,
                  color: context.watch<ThemeCubit>().state.isDarkTheme == false
                      ? Colors.black45
                      : Colors.white38,
                ),
                label: Text(
                  'Update',
                  style: TextStyle(
                    color: context.watch<ThemeCubit>().state.isDarkTheme == false
                        ? Colors.black45
                        : Colors.white38,
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: showEditingTools,
            child: Icon(Icons.edit_attributes_outlined),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quill Toolbar
                _showTools
                    ? QuillSimpleToolbar(
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
                      )
                    : const SizedBox(),
                // Quill Editor
                Expanded(
                  child: QuillEditor(
                    scrollController: _scrollController,
                    focusNode: FocusNode(),
                    controller: _quillController,
                    config: const QuillEditorConfig(
                      showCursor: true,
                      padding: EdgeInsets.all(0),
                      autoFocus: false,
                      scrollable: true,
                      placeholder: 'Note content...',
                      enableSelectionToolbar: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

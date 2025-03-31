import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/config/router/navigates_to.dart';
import 'package:note_app/config/router/routes_name.dart';
import 'package:note_app/data/models/local_note_model/note_model.dart';
import 'package:note_app/helpers/hive_manager.dart';
import 'package:note_app/state/cubits/note_style_cubit/note_style_cubit.dart';
import 'package:note_app/state/cubits/theme_cubit/theme_cubit.dart';
import 'package:note_app/utils/colors/m_colors.dart';

class LocalNotesScreen extends StatefulWidget {
  const LocalNotesScreen({Key? key}) : super(key: key);

  @override
  _LocalNotesScreenState createState() => _LocalNotesScreenState();
}

class _LocalNotesScreenState extends State<LocalNotesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final storeData = HiveManager().noteModelBox;
    return BlocBuilder<NoteStyleCubit, NoteStyleState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Notes'),
            // TODO:* adding support for localization soon.
            actions: [
              if (Platform.isIOS)
                IconButton(
                  onPressed: () {
                    navigateReplaceTo(context,
                        destination: RoutesName.create_notes_screen);
                  },
                  icon: const Icon(
                    CupertinoIcons.add_circled,
                  ),
                ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              navigateReplaceTo(context,
                  destination: RoutesName.create_notes_screen);
            },
            backgroundColor:
                context.watch<ThemeCubit>().state.isDarkTheme == true
                    ? AppColors.cardColor
                    : AppColors.primaryColor,
            tooltip: 'Add Note',
            child: Icon(
              Icons.add,
              color: AppColors.defaultBlack,
            ),
          ),
          body: storeData.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No Notes Yet... \n(Tap on the Add Button below)',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Icon(
                        Icons.arrow_downward_sharp,
                        size: 60,
                      )
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: storeData!.listenable(),
                      builder: (context, Box<NoteModel> notes, _) {
                        List<int>? keys = notes.keys.cast<int>().toList();
                        return MasonryGridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          primary: false,
                          shrinkWrap: true,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                          addRepaintBoundaries: true,
                          itemCount: keys.length,
                          gridDelegate:
                              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (_, index) {
                            final key = keys[index];
                            final NoteModel? note = notes.get(key);

                            // Get plain text preview from the Quill content
                            final notesPreview = note!.getPlainText();

                            return GestureDetector(
                              onTap: () {
                                navigateTo(context,
                                    destination: RoutesName.read_notes_screen,
                                    arguments: {
                                      'note': note,
                                      'noteKey': key,
                                    });
                              },
                              onLongPress: () {
                                deleteDialog(key, note);
                              },
                              child: note.title == null || note.title!.isEmpty
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white38,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          notesPreview,
                                          style: const TextStyle(),
                                          softWrap: true,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white38,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                color: context
                                                            .watch<ThemeCubit>()
                                                            .state
                                                            .isDarkTheme ==
                                                        false
                                                    ? AppColors.primaryColor
                                                    : Colors.grey[900],
                                              ),
                                              child: Text(
                                                note.title ?? 'No Title',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                softWrap: true,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Text(
                                                notesPreview.length > 70
                                                    ? '${notesPreview.substring(0, 70)}...'
                                                    : notesPreview,
                                                style: const TextStyle(),
                                                softWrap: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
        );
      },
    );
  }

  void deleteDialog(key, NoteModel note) {
    final storeData = HiveManager().noteModelBox;
    final deletedData = HiveManager().deleteNoteModelBox;
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                NoteModel noteToDelete = NoteModel(
                  title: note.title,
                  notes: note.notes,
                );
                deletedData!.add(noteToDelete);
                storeData!.delete(key);
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

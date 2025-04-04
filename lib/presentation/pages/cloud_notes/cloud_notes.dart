import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/config/router/navigates_to.dart';
import 'package:note_app/config/router/routes_name.dart';
import 'package:note_app/data/models/cloud_note_models/cloud_note_model.dart';
import 'package:note_app/helpers/hive_manager.dart';
import 'package:note_app/state/cubits/cloud_note_cubit/cloud_note_cubit.dart';
import 'package:note_app/state/cubits/theme_cubit/theme_cubit.dart';
import 'package:note_app/utils/colors/m_colors.dart';
import 'package:note_app/utils/tools/message_dialog.dart';
import 'package:provider/provider.dart';

class CloudNotesScreen extends StatefulWidget {
  const CloudNotesScreen({super.key});

  @override
  State<CloudNotesScreen> createState() => _CloudNotesScreenState();
}

class _CloudNotesScreenState extends State<CloudNotesScreen> {
  void deleteDialog(key, CloudNoteModel note) {
    final storeData = HiveManager().cloudNoteModelBox;
    showDialog(
      context: context,
      builder: (_) {
        return BlocListener<CloudNoteCubit, CloudNoteState>(
          listener: (context, state) {
            if (state is CloudNoteDeleted) {
              context.read<CloudNoteCubit>().fetchNotes();
              Navigator.pop(context);
            } else if (state is CloudError) {
              showError(state.message);
            }
          },
          child: AlertDialog(
            title: const Text('Warning'),
            content: const Text('Are you sure you want to delete this note?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'No',
                ),
              ),
              TextButton(
                onPressed: () {
                  storeData.delete(key);
                  context.read<CloudNoteCubit>().deleteNote(note);
                },
                child: const Text(
                  'Yes',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<CloudNoteCubit>().fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:FloatingActionButton(
              onPressed: () {
                navigateReplaceTo(context,
                    destination: RoutesName.cloud_create_notes_screen);
              },
              backgroundColor:
                  context.watch<ThemeCubit>().state.isDarkTheme == true
                      ? AppColors.cardColor
                      : AppColors.primaryColor,
              tooltip: 'Add Note',
              child: Icon(Icons.add, color: AppColors.defaultBlack),
            ),
      body: BlocBuilder<CloudNoteCubit, CloudNoteState>(
        builder: (context, state) {

          if (state is CloudNoteLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CloudNoteLoaded) {

            if (state.notes.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No Notes Yet... \n(Tap on the Add Button below)',
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Icon(Icons.arrow_downward_sharp, size: 60)
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
                child: MasonryGridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  primary: false,
                  shrinkWrap: true,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  addRepaintBoundaries: true,
                  itemCount: state.notes.length,
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (_, index) {
                    final note = state.notes[index];
                    final hiveKey = state.hiveKeys[index];
                    return GestureDetector(
                      onTap: () {
                        // Your navigation logic
                        navigateTo(context,
                            destination: RoutesName.cloud_read_notes_screen,
                            arguments: {
                              'note': note,
                              'noteKey': hiveKey,
                            });
                      },
                      onLongPress: () {
                        // Your delete dialog logic
                        deleteDialog(hiveKey, note);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: context
                                              .watch<ThemeCubit>()
                                              .state
                                              .isDarkTheme ==
                                          false
                                      ? AppColors.primaryColor
                                      : AppColors.cardGray,
                                ),
                                child: Text(
                                  note.title == null || note.title == ''
                                      ? 'No Title'
                                      : '${note.title}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Flexible(
                                fit: FlexFit.loose,
                                child: Column(
                                  children: [
                                    Text(
                                      '${note.notes!.length >= 70 ? '${note.notes!.substring(0, 70)}...' : note.notes}',
                                      style: const TextStyle(),
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }

          if (state is CloudError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text('No notes'));
        },
      ),
    );
  }
}

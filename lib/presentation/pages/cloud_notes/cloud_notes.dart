import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/app/helpers/hive_manager.dart';
import 'package:note_app/app/resources/home/views/cloud_notes/models/cloud_note_model.dart';
import 'package:note_app/app/resources/home/views/cloud_notes/views/cloud_read_note_screen.dart';
import 'package:note_app/app/router/route_name.dart';
import 'package:note_app/m_functions/navigate_to.dart';
import 'package:note_app/request/get_request.dart';
import 'package:note_app/request/post_request.dart';
import 'package:note_app/state/cubits/theme_cubit/theme_cubit.dart';
import 'package:note_app/utils/const_values.dart';
import 'package:note_app/utils/tools/message_dialog.dart';
import 'package:provider/provider.dart';

class CloudNotesScreen extends StatefulWidget {
  const CloudNotesScreen({super.key});

  @override
  State<CloudNotesScreen> createState() => _CloudNotesScreenState();
}

class _CloudNotesScreenState extends State<CloudNotesScreen> {
  bool isLoading = false;

  Future fetchNotes() async {
    final userModel = HiveManager().userModelBox;
    final cloudNoteModel = HiveManager().cloudNoteModelBox;

    var res = await GetRequest.makeGetRequest(
      requestEnd: 'user/fetch_notes',
      bearer: userModel.get(tokenKey)!.accessToken,
      context: context,
    );

    logger.i(res);

    var status = res['status'];
    var msg = res['message'];

    try {
      if (status == 200) {
        List<CloudNoteModel> cloudNotes = CloudNoteModel.parseResponse(res);
        await cloudNoteModel.clear();
        await cloudNoteModel.addAll(cloudNotes);

        setState(() {});
        logger.i('Notes stored successfully');
      }
    } catch (error) {
      if (error.toString().contains('Unhandled Exception')) {
        showError('Something went wrong, it\'s not you it\'s us.');
      }
    }
  }

  Future trashNote(String? uuid) async {
    setState(() {
      isLoading = true;
    });

    final userModel = HiveManager().userModelBox;

    var params = {
      'note_uuid': '$uuid',
    };

    var res = await PostRequest.makePostRequest(
      requestEnd: 'user/trash_note',
      params: params,
      context: context,
      bearer: userModel.get(tokenKey)!.accessToken,
    );

    logger.i(res);

    var status = res['status'];
    var msg = res['message'];

    try {
      if (status == 200) {
        Fluttertoast.showToast(
          msg: '$msg',
          toastLength: Toast.LENGTH_SHORT,
        );

        if (mounted) {
          fetchNotes();
        }
      }
    } catch (error) {
      if (error.toString().contains('Unhandled Exception')) {
        showError('Something went wrong, it\'s not you it\'s us.');
      }
      setState(() {
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void deleteDialog(key, CloudNoteModel note) {
    final storeData = HiveManager().cloudNoteModelBox;
    showDialog(
      context: context,
      builder: (_) {
        return Platform.isAndroid
            ? AlertDialog(
                title: const Text('Warning'),
                content:
                    const Text('Are you sure you want to delete this note?'),
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
                      Navigator.of(context).pop();
                      setState(() {});
                      trashNote(note.uuid);
                    },
                    child: const Text(
                      'Yes',
                    ),
                  ),
                ],
              )
            : CupertinoAlertDialog(
                title: const Text('Warning'),
                content:
                    const Text('Are you sure you want to delete this note?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'No',
                      style: TextStyle(),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      storeData.delete(key);
                      Navigator.of(context).pop();
                      setState(() {});
                      trashNote(note.uuid);
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(),
                    ),
                  ),
                ],
              );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    final cloudNoteModel = HiveManager().cloudNoteModelBox;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        // TODO:* adding support for localization soon.
        actions: [
          if (Platform.isIOS)
            IconButton(
              onPressed: () {
                context.pop();
                context.pushNamed(RouteName.cloud_create_notes_screen);
              },
              icon: const Icon(
                CupertinoIcons.add_circled,
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isAndroid
          ? FloatingActionButton(
              onPressed: () {
                context.pop();
                context.pushNamed(RouteName.cloud_create_notes_screen);
              },
              backgroundColor:
              context.watch<ThemeCubit>().state.isDarkTheme == true ? cardColor : backColor,
              tooltip: 'Add Note',
              child: const Icon(
                Icons.add,
                color: defaultBlack,
              ),
            )
          : null,
      body: cloudNoteModel.isNotEmpty
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ValueListenableBuilder(
                  valueListenable: cloudNoteModel.listenable(),
                  builder: (context, Box<CloudNoteModel> notes, _) {
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
                        final CloudNoteModel? note = notes.get(key);
                        return GestureDetector(
                          onTap: () {
                            navigateTo(context,
                                destination: CloudReadNote(
                                  note: note,
                                  noteKey: key,
                                ));
                          },
                          onLongPress: () {
                            deleteDialog(key, note);
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white38,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
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
                                      color: context.watch<ThemeCubit>().state.isDarkTheme == false
                                          ? backColor
                                          : Colors.grey[900],
                                    ),
                                    child: Text(
                                      note!.title == null || note.title == ''
                                          ? 'No Title'
                                          : '${note.title}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
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
                    );
                  },
                ),
              ),
            )
          : const Center(
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
            ),
    );
  }
}

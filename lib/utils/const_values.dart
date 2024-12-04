import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:note_app/utils/constant/api_constant.dart';
import 'package:note_app/utils/tools/hex_to_color.dart';

var logger = Logger();

// String apiUrl = dotenv.env['API_URL'].toString();
// String payStackPubKey = dotenv.env['PAYSTACK_PUB_KEY'].toString();
// String payStackSecKey = dotenv.env['PAYSTACK_SEC_KEY'].toString();

String apiUrl = ApiConstants.apiUrl;

const String androidID = 'com.viewus.v_notes';
const String dialogTitle = 'Update V Notes';
const String dialogText = 'There is a new update for V Notes, '
    'would you like to update to check up '
    'what we have improved about the app';

// Hive details
const String noteBox = 'notebox';
const String cloudNoteBox = 'cloudNoteBox';
const String userBox = 'userBox';
const String deletedNotes = 'deletedNotes';
const String appHiveKey = 'state';
const String deleteNote = 'deleteNote';


const String userKey = 'userKey';
const String tokenKey = 'tokenKey';

Color transparent = Colors.transparent;
Color grey = hexToColor('#AFACAB');
Color mGrey = grey.withOpacity(0.4);

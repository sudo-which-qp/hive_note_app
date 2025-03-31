import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel {
  @HiveField(0)
  final String? title;

  @HiveField(1)
  final String? notes;

  @HiveField(2)
  final dynamic dateTime;

  NoteModel({
    this.title,
    this.notes,
    this.dateTime,
  });

  QuillController get quillController {
    try {
      // Try to parse as Quill JSON
      final List<dynamic> jsonData = jsonDecode(notes ?? "");
      final delta = Delta.fromJson(jsonData);
      final document = Document.fromDelta(delta);

      return QuillController(
        document: document,
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (e) {
      // If parsing fails, it's likely a legacy note with plain text
      // Create a Document with the plain text content
      final delta = Delta()
        ..insert(notes ?? "")
        ..insert('\n'); // Ensure it ends with a newline for proper formatting

      final document = Document.fromDelta(delta);

      return QuillController(
        document: document,
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
  }

  // Extract plain text from notes (whether it's Quill JSON or plain text)
  String getPlainText() {
    try {
      // Try to parse as Quill JSON first
      final List<dynamic> jsonData = jsonDecode(notes ?? "");
      final delta = Delta.fromJson(jsonData);
      final document = Document.fromDelta(delta);
      return document.toPlainText().trim();
    } catch (e) {
      // If parsing fails, return the raw text
      return notes ?? "";
    }
  }
}

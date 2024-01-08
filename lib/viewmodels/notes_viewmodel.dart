import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Note.dart';

class NotesViewModel extends ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  TextEditingController todoTitleController = TextEditingController();

  void saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedNotes = _notes.map((note) {
      return '${note.title},${note.description}';
    }).toList();
    Future<bool> future = prefs.setStringList('notes', savedNotes);

    future.then((value) {
      if (value) notifyListeners();
    });
  }

  Future loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _notes = (prefs.getStringList('notes') ?? []).map((note) {
      List<String> noteData = note.split(',');
      return Note(
        title: noteData[0],
        description: noteData[1],
      );
    }).toList();
    notifyListeners();
  }

  void addNote(Note note) {
    _notes.add(note);
    saveNotes();
  }

  void editNote(Note note, int index) {
    _notes[index] = note;
    saveNotes();
  }

  void deleteNote(int index) {
    _notes.removeAt(index);
    saveNotes();
  }
}

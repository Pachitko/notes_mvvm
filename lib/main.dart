import 'package:flutter/material.dart';
import 'package:notes_mvvm/viewmodels/notes_viewmodel.dart';
import 'package:notes_mvvm/views/note_list_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final notesViewModel = NotesViewModel();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotesViewModel>(
      create: (context) => notesViewModel,
      child: MaterialApp(
        title: 'Заметки',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NoteListPage(),
      ),
    );
  }
}

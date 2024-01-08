import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_mvvm/viewmodels/notes_viewmodel.dart';
import 'package:provider/provider.dart';
import '../models/Note.dart';
import 'note_edit_page.dart';

class NoteListPage extends StatefulWidget {
  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  late NotesViewModel todoViewModel;

  @override
  void initState() {
    super.initState();
  }

  void addNote() async {
    Note? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteEditPage()),
    );
    if (result != null) {
      setState(() {
        todoViewModel.addNote(result);
      });
    }
  }

  void editNote(int index) async {
    Note? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditPage(note: todoViewModel.notes[index]),
      ),
    );
    if (result != null) {
      setState(() {
        todoViewModel.editNote(result, index);
      });
    }
  }

  void deleteNote(int index) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить заметку?'),
          content: const Text('Вы действительно хотите удалить эту заметку?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
    if (confirm != null && confirm) {
      setState(() {
        todoViewModel.deleteNote(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    todoViewModel = Provider.of<NotesViewModel>(context);
    todoViewModel.loadNotes();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Заметки'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
        ),
        itemCount: todoViewModel.notes.length,
        itemBuilder: (context, index) {
          String title = todoViewModel.notes[index].title;
          String description = todoViewModel.notes[index].description;
          return Card(
            child: ListTile(
              title: Text(title),
              subtitle: Text(description),
              onTap: () => editNote(index),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deleteNote(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}

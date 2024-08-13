import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_notes_hive/models/note.dart';
import 'package:minimal_notes_hive/models/note_database.dart';
import 'package:minimal_notes_hive/pages/notes_page.dart';
import 'package:provider/provider.dart';

class NoteViewPage extends StatelessWidget {
  final Note? note;
  final String title;
  final String text;
  final bool isUpdating;

  const NoteViewPage({
    super.key,
    this.note,
    required this.title,
    required this.text,
    required this.isUpdating,
  });

  @override
  Widget build(BuildContext context) {
    // text controller to access what the user typed
    final textControllerTitle = TextEditingController();
    final textControllerContent = TextEditingController();
    textControllerTitle.text = title;
    textControllerContent.text = text;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: TextField(
          decoration: InputDecoration(
              hintText: 'Title',
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.secondary),
              border: InputBorder.none),
          style: GoogleFonts.dmSerifText(
            fontSize: 32,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          controller: textControllerTitle,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                if (isUpdating && note != null) {
                  // Aktualizacja w bazie danych
                  note!.title = textControllerTitle.text;
                  note!.text = textControllerContent.text;
                  await note!.save(); // Zapisanie zmian w obiekcie Hive
                  context
                      .read<NoteDatabase>()
                      .fetchNotes(); // Pobierz zaktualizowane notatki
                } else {
                  // Dodanie do bazy danych
                  await context.read<NoteDatabase>().addNote(
                        textControllerTitle.text,
                        textControllerContent.text,
                      );
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotesPage(),
                  ),
                );
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: textControllerContent,
                keyboardType: TextInputType.multiline,
                maxLines: null, // Allows unlimited lines
                expands: true, // Expands to fill available space
                decoration: InputDecoration(
                  hintText: 'Start typing your note...',
                  hintStyle:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                  border: InputBorder.none, // Removes underline
                ),
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

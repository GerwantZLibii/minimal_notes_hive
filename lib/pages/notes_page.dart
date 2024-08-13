import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_notes_hive/components/drawer.dart';
import 'package:minimal_notes_hive/components/note_tile.dart';
import 'package:minimal_notes_hive/models/note.dart';
import 'package:minimal_notes_hive/models/note_database.dart';
import 'package:minimal_notes_hive/pages/note_view_page.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  @override
  void initState() {
    super.initState();

    readNotes();
  }

  // create a note
  void createNote() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NoteViewPage(
          title: "",
          text: "",
          isUpdating: false,
        ),
      ),
    );
  }

  // read notes
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  // update a note
  void updateNote(Note note) {
    Note? updatedNote = note;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteViewPage(
          note: updatedNote,
          title: note.title,
          text: note.text,
          isUpdating: true,
        ),
      ),
    );
  }

  // delete a note
  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    // note database
    final noteDatabase = context.watch<NoteDatabase>();

    // current notes
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(onPressed: createNote, icon: const Icon(Icons.add),)
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        onPressed: createNote,
        child: const Icon(Icons.add),
      ),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADING
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'Notes',
              style: GoogleFonts.dmSerifText(
                fontSize: 48,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),

          // LIST OF NOTES
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20,),
              child: ListView.builder(
                itemCount: currentNotes.length,
                itemBuilder: (context, index) {
                  // Pobierz poszczególną notatkę
                  final note = currentNotes[index];
              
                  // UI listy notatek
                  return NoteTile(
                    title: note.title,
                    text: note.text,
                    onEditPressed: () => updateNote(note),
                    onDeletePressed: () =>
                        deleteNote(note.key), // Używamy note.key zamiast note.id
                    onTap: () => updateNote(note),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

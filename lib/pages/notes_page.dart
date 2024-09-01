import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_notes_hive/components/drawer.dart';
import 'package:minimal_notes_hive/components/note_list.dart';
import 'package:minimal_notes_hive/components/note_tile.dart';
import 'package:minimal_notes_hive/components/selection_mode_provider.dart';
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

  void _deleteSelectedNotes() {
    final noteDatabase = context.read<NoteDatabase>();
    final selectedNotes = context.read<SelectionModeProvider>().selectedNotes;

    selectedNotes.forEach((index) {
      noteDatabase.deleteNote(noteDatabase.currentNotes[index].key);
    });

    context.read<SelectionModeProvider>().toggleSelectionMode(false);
  }

  @override
  Widget build(BuildContext context) {
    // note database
    final noteDatabase = context.watch<NoteDatabase>();
    final isSelectionMode = context.watch<SelectionModeProvider>().isSelectionMode;
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: isSelectionMode
            ? [
                IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    context.read<SelectionModeProvider>().toggleSelectionMode(false);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Add logic to delete selected notes
                    _deleteSelectedNotes();
                    context.read<SelectionModeProvider>().toggleSelectionMode(false);
                  },
                ),
              ]
            : [
                IconButton(
                  onPressed: createNote,
                  icon: const Icon(Icons.add),
                ),
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
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              child: NoteList(
                notes: currentNotes,
                onDeletePressed: (note) => deleteNote(note.key),
                onEditPressed: (note) => updateNote(note),
                onCancelPressed: (context) {},
              ),
            ),
          )
        ],
      ),
    );
  }
}

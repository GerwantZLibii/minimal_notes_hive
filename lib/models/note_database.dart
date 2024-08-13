import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:minimal_notes_hive/models/note.dart';

class NoteDatabase extends ChangeNotifier {
  static late Box<Note> notesBox;

  // Inicjalizacja bazy danych Hive
  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(NoteAdapter());
    notesBox = await Hive.openBox<Note>('notesBox');
  }

  // Lista notatek
  final List<Note> currentNotes = [];

  // Dodawanie nowej notatki i zapisywanie jej do bazy danych
  Future<void> addNote(String title, String noteContent) async {
    // Tworzenie nowego obiektu Note
    final newNote = Note()
      ..title = title
      ..text = noteContent;

    // Zapis do bazy danych
    await notesBox.add(newNote);

    // Ponowne odczytanie z bazy danych
    fetchNotes();
  }

  // Odczytywanie notatek z bazy danych
  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = notesBox.values.toList();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }

  // Aktualizacja notatki w bazie danych
  Future<void> updateNote(int index, String title, String noteContent) async {
    final existingNote = notesBox.getAt(index);
    if (existingNote != null) {
      existingNote.title = title;
      existingNote.text = noteContent;
      await existingNote.save();
      await fetchNotes();
    }
  }

  // Usuwanie notatki z bazy danych
  Future<void> deleteNote(int index) async {
    await notesBox.deleteAt(index);
    await fetchNotes();
  }
}

import 'package:flutter/material.dart';
import 'package:minimal_notes_hive/components/selection_mode_provider.dart';
import 'package:minimal_notes_hive/models/note_database.dart';
import 'package:minimal_notes_hive/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'pages/notes_page.dart';

void main() async {
  //initialize note isar database
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();

  runApp(
    MultiProvider(
      providers: [
        // Note Provider
        ChangeNotifierProvider(create: (context) => NoteDatabase()),
        // Theme Provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        // SelectionMode Provider
        ChangeNotifierProvider(create: (context) => SelectionModeProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NotesPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
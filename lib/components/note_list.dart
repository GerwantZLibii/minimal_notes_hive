import 'package:flutter/material.dart';
import 'package:minimal_notes_hive/components/selection_mode_provider.dart';
import 'package:provider/provider.dart';
import 'note_tile.dart';
import 'package:minimal_notes_hive/models/note.dart';

class NoteList extends StatefulWidget {
  final List<Note> notes;
  final void Function(Note note) onDeletePressed;
  final void Function(Note note) onEditPressed;
  final void Function(Note note) onCancelPressed;

  const NoteList({
    Key? key,
    required this.notes,
    required this.onDeletePressed,
    required this.onEditPressed,
    required this.onCancelPressed,
  }) : super(key: key);

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  final Set<int> selectedNotes = {};

  void _onNoteLongPress(int noteIndex) {
    setState(() {
      context.read<SelectionModeProvider>().toggleSelectionMode(true);
      context.read<SelectionModeProvider>().selectedNotes.add(noteIndex);
    });
  }

  void _onCheckboxChanged(bool? value, int noteIndex) {
    setState(() {
      if (value == true) {
        context.read<SelectionModeProvider>().selectedNotes.add(noteIndex);
      } else {
        context.read<SelectionModeProvider>().selectedNotes.remove(noteIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.notes.length,
      itemBuilder: (context, index) {
        final note = widget.notes[index];
        final isSelected = context.read<SelectionModeProvider>().selectedNotes.contains(index);

        return NoteTile(
          title: note.title,
          text: note.text,
          isSelected: isSelected,
          isSelectionMode: context.read<SelectionModeProvider>().isSelectionMode,
          onTap: () {
            if (context.read<SelectionModeProvider>().isSelectionMode) {
              _onCheckboxChanged(!isSelected, index);
            } else {
              widget.onEditPressed(note);
            }
          },
          onLongPress: () => _onNoteLongPress(index),
          onCheckboxChanged: (value) => _onCheckboxChanged(value, index),
          onDeletePressed: () => widget.onDeletePressed(note),
        );
      },
    );
  }
}

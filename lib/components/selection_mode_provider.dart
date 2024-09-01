import 'package:flutter/material.dart';

class SelectionModeProvider with ChangeNotifier {
  bool _isSelectionMode = false;
  final Set<int> _selectedNotes = {};

  bool get isSelectionMode => _isSelectionMode;
  Set<int> get selectedNotes => _selectedNotes;

  void toggleSelectionMode(bool isActive) {
    _isSelectionMode = isActive;
    if (!isActive) {
      _selectedNotes.clear();
    }
    notifyListeners();
  }

  void toggleNoteSelection(int noteIndex, bool isSelected) {
    if (isSelected) {
      _selectedNotes.add(noteIndex);
    } else {
      _selectedNotes.remove(noteIndex);
    }
    notifyListeners();
  }
}

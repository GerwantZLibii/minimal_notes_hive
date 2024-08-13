import 'package:hive/hive.dart';

// Upewnij się, że wygenerowany plik adaptera będzie widoczny
part 'note.g.dart';

@HiveType(typeId: 0) // Użyj unikalnego typeId dla każdej klasy
class Note extends HiveObject {
  @HiveField(0) // Każde pole musi mieć unikalny index
  late String title;

  @HiveField(1)
  late String text;
}

String getDisplayedTitle(String title, String text, int maxLength) {
  return title.trim().isEmpty ? truncateWithEllipsis(text, maxLength) : title;
}

String truncateWithEllipsis(String text, int maxLength) {
  if (text.length <= maxLength) {
    return text;
  }
  return '${text.substring(0, maxLength)}...';
}

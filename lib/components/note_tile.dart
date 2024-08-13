import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimal_notes_hive/models/note.dart';
import 'package:minimal_notes_hive/components/note_settings.dart';
import 'package:popover/popover.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NoteTile extends StatelessWidget {
  final String title;
  final String text;
  final void Function()? onEditPressed;
  final void Function()? onDeletePressed;
  final void Function()? onTap;

  const NoteTile({
    super.key,
    required this.title,
    required this.text,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayedTitle = getDisplayedTitle(title, text, 15);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(
        top: 10,
        left: 25,
        right: 25,
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Slidable(
          startActionPane: ActionPane(motion: const DrawerMotion(), children: [
            SlidableAction(
              onPressed: ((context) {}),
              icon: Icons.push_pin_rounded,
              backgroundColor: Colors.yellow.shade50,
              foregroundColor: const Color.fromARGB(255, 255, 230, 0),
              borderRadius: BorderRadius.circular(8),
            ),
          ]),
          endActionPane: ActionPane(motion: const DrawerMotion(), children: [
            SlidableAction(
              onPressed: ((context) {}),
              icon: Icons.share_rounded,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.blueGrey.shade50 // Dark mode background color
                  : Colors.blue.shade50, // Light mode background color
              foregroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.blueGrey.shade400 // Dark mode icon color
                  : const Color.fromARGB(
                      255, 41, 98, 255), // Light mode icon color
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            SlidableAction(
              onPressed: ((context) {}),
              icon: Icons.delete_rounded,
              backgroundColor: Colors.red.shade50,
              foregroundColor: const Color.fromARGB(255, 255, 41, 41),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            )
          ]),
          child: ListTile(
            title: Text(
              displayedTitle,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
            trailing: Builder(builder: (context) {
              return IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => showPopover(
                  width: 97,
                  height: 100,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  context: context,
                  bodyBuilder: (context) => NoteSettings(
                    onEditTap: onEditPressed,
                    onDeleteTap: onDeletePressed,
                  ),
                ),
              );
            }),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}

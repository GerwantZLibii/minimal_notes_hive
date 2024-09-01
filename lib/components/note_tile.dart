import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:minimal_notes_hive/models/note.dart';

class NoteTile extends StatelessWidget {
  final String title;
  final String text;
  final bool isSelected;
  final bool isSelectionMode;
  final void Function()? onDeletePressed;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function(bool?)? onCheckboxChanged;

  const NoteTile({
    super.key,
    required this.title,
    required this.text,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onDeletePressed,
    required this.onTap,
    required this.onLongPress,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    final displayedTitle = getDisplayedTitle(title, text, 15);

    return Container(
      margin: const EdgeInsets.only(
        top: 10,
        left: 25,
        right: 25,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: isSelectionMode ? MediaQuery.of(context).size.width * 0.75 : MediaQuery.of(context).size.width * 0.85  ,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary.withOpacity(0.3)
                      : Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.hardEdge,
                child: Slidable(
                  startActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: ((context) {}),
                        icon: Icons.push_pin_rounded,
                        backgroundColor: Colors.yellow.shade50,
                        foregroundColor: const Color.fromARGB(255, 255, 230, 0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: ((context) {}),
                        icon: Icons.share_rounded,
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.blueGrey.shade50
                                : Colors.blue.shade50,
                        foregroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.blueGrey.shade400
                                : const Color.fromARGB(255, 41, 98, 255),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          onDeletePressed?.call();
                        },
                        icon: Icons.delete_rounded,
                        backgroundColor: Colors.red.shade50,
                        foregroundColor: const Color.fromARGB(255, 255, 41, 41),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      )
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      displayedTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    trailing: isSelectionMode
                        ? null
                        : Builder(
                            builder: (context) {
                              return IconButton(
                                icon: const Icon(Icons.delete_rounded),
                                onPressed: onDeletePressed,
                              );
                            },
                          ),
                    onTap: onTap,
                    onLongPress: onLongPress,
                  ),
                ),
              ),
              
              ]
            ),
          ),
          AnimatedOpacity(
            opacity: (isSelected || onCheckboxChanged != null) && isSelectionMode ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Checkbox(
                value: isSelected,
                onChanged: onCheckboxChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

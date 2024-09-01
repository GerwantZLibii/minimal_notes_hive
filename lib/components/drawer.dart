import 'package:flutter/material.dart';
import 'package:minimal_notes_hive/pages/settings_page.dart';
import 'package:minimal_notes_hive/components/drawer_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // header
          const DrawerHeader(
            child: Icon(Icons.book),
            ),

          // notes tile
          DrawerTile(
            title: "Notes", 
            leading: const Icon(Icons.home), 
            onTap: () => Navigator.pop(context),
          ),

          // settings tile
          DrawerTile(
            title: "Settings", 
            leading: const Icon(Icons.settings), 
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}